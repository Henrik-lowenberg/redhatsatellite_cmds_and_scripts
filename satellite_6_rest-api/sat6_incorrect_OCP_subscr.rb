#!/usr/bin/env ruby

require 'rest-client'
require 'json'
begin
  url = 'https://sat6host.some.domain/api/v2/'
  katello_url = "https://sat6host.some.domain/katello/api"
  $username = 'sat6user'
  $password = 'changeme'
  org_name = "ORG"
  org_id = 1

  # Performs a GET using the passed URL location
  def get_json(location)
      response = RestClient::Request.new(
          :method => :get,
          :url => location,
          :user => $username,
          :password => $password,
          :headers => { :accept => :json,
          :content_type => :json }
      ).execute
      results = JSON.parse(response.to_str)
  end

  # Performs a POST and passes the data to the URL location
  def post_json(location, json_data)
      response = RestClient::Request.new(
          :method => :post,
          :url => location,
          :user => $username,
          :password => $password,
          :headers => { :accept => :json,
          :content_type => :json},
          :payload => json_data
      ).execute
      results = JSON.parse(response.to_str)
  end

  # Creates a hash with ids mapping to names for an array of records
  def id_name_map(records)
    records.inject({}) do |map, record|
      map.update(record['id'] => record['name'])
    end
  end

  # Creates a hash with ids mapping to names for an array of records
  def id_name_map2(records)
    records.inject({}) do |map, record|
      map.update(record['hostid'] => record['name'])
    end
  end

  # ---------------------------------------------  #
  # Get Red Hat OpenShift Container Platform for Certified Cloud and Service Providers subscription, no 132
  # You need to identify your own no with hammer
  ocp_subscription = get_json("#{katello_url}/organizations/#{org_id}/subscriptions/132")

#  p ocp_subscription.class
#  p ocp_subscription.inspect
  ocphosts = ocp_subscription['systems']
# p ocphosts.class
# p ocphosts.inspect
# ocphosts is an array, each element is a hash
  hostnames = Array.new
  hostids = Array.new
  ocphosts.each do |hashelement|
    hostnames <<  hashelement['name']
    hostids << hashelement['host_id']
  end  

  # --------------------------------------------- #
  # Get content host addon parameter value
  showHostsInfo = Array.new
  hostids.each do |hostid|
    showHostsInfo << get_json("#{url}/hosts/#{hostid}")
  end

  y = 1
    showHostsInfo.each do |x|
      #p x.class
      #p x.inspect
      #puts "#{hostnames[y]}"
      x['parameters'].each do |params| 
        if params['name'].eql? "addon" and params['value'] !~ /openshift/
          puts "#{hostnames[y]} #{params['name']} #{params['value']}"
        end
      end
      y += 1
    end
  
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

