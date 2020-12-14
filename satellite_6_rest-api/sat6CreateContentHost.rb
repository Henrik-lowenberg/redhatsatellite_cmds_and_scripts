#!/usr/bin/env ruby

require 'uri'
require 'rest-client'
require 'json'
require 'timeout'

SATELLITE_HOST_ID = 'satellite_host_id'
organization_id = '1'
location_id = '3'
method = 'create_satellite_host'
satellite_host = 'ssat6host.some.domain'
satellite_username = 'sat6user'
satellite_password = 'changeme'


def invoke_satellite_api(http_method, url, satellite_username, satellite_password, api_timeout, payload)
  
  begin
    Timeout.timeout(api_timeout) do
      result = JSON.load(RestClient::Request.execute({
        :method   => http_method,
        :url      => url,
        :user     => satellite_username,
        :password => satellite_password,
        :payload  => payload,
        :timeout  => api_timeout,
        :ssl_verify => false,
        :headers  => {:accept=>'version=2', :content_type => 'application/json'}
      }))
      return result
    end
  end
end


def create_host(vm_host_name, ip_addr, vm_mac_address, satellite_hostgroup_id, build, organization_id, location_id, domain_id, subnet_id, managed, request, ifarray)
  host = {
    'name'                  => vm_host_name,
    'hostgroup_id'          => satellite_hostgroup_id,
    'build'                 => build, 
    'organization_id'       => organization_id,
    'location_id'           => location_id,
    'managed'               => managed,
    'domain_id'				=> domain_id,
    'interfaces_attributes' => ifarray,
  }
  
  value = {
    'host'                  => host,
  }
  
  infrastructure_environment = get_infrastructure_environment(request)
  infra_env_config           = retrieve_configuration('InfrastructureEnvironments', infrastructure_environment)
  satellite_host             = infra_env_config['satellite_host']
  url                        = "https://#{satellite_host}/api/hosts"
  satellite_username         = infra_env_config['satellite_username']
  satellite_password         = infra_env_config['satellite_password']
  api_timeout                = 60
  payload                    = value.to_json #V2 Satellite API requires JSON string
  http_method                = :post
  
  result = invoke_satellite_api(http_method, url, satellite_username, satellite_password, api_timeout, payload)
  satellite_host_id = result['id']
  
  return result, satellite_host_id
end


begin
  
  vm_name                 = $evm.current['vm_name']
  vm_mac_address          = $evm.current['vm_mac_address']
  satellite_hostgroup_id  = $evm.current['satellite_hostgroup_id']
  build                   = $evm.current['build']
  managed                 = $evm.current['managed']
  #TODO: improve how these 4 values are set or even fetch them from satellite more dynamic
  organization_id         = $evm.object['organization_id']
  location_id             = $evm.object['location_id']
  #domain_id		      = $evm.object['domain_id']
  #subnet_id  		      = $evm.object['subnet_id']
  domain_id		          = $evm.current['domainid']
  subnet_id  		      = $evm.current['subnetid']
  second_ip				  = $evm.current['secondip']
  second_mac		      = $evm.current['secondmac']
  second_subnetid		  = $evm.current['secondsubnetid']
  
  interfacearray = [ 
    {
      "primary" => true,
      "ip" => ipaddr,
      "mac" => vm_mac_address,
      "provision" => true,
      "managed" => managed,
      "virtual" => false,
      "subnet_id" => subnet_id,
     },
    ]
  log("Initial interface array: #{interfacearray}")
  
  unless second_ip.blank? or second_mac.blank? or second_subnetid.blank?
  	addinterface = [ 
      {
        "primary" => false,
        "ip" => second_ip,
        "mac" => second_mac,
        "provision" => false,
        "managed" => true,
        "subnet_id" => second_subnetid,
        },
      ]
    interfacearray = interfacearray + addinterface
  end
  
 
  
  result, satellite_host_id = create_host(vm_name, ipaddr, vm_mac_address, satellite_hostgroup_id, build, organization_id, location_id, domain_id, subnet_id, managed, request, interfacearray)
  
  
end


rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

