#!/usr/bin/tfm-ruby
require 'apipie-bindings'
require 'json'

org_name = "ORG"
#org_id = 1
environments = [ "dev", "qa", "prod" ]

begin
  #Create an instance of apipie bindings
  @api = ApipieBindings::API.new({
    :uri => 'https://sat6host.some.domain/',
    :username => 'sat6user',
    :password => 'changeme',
    :api_version => 2
  })

  # Performs an API call with default options
  def call_api(resource_name, action_name, params = {})
    http_headers = {}
    apipie_options = { :skip_validation => true }
    @api.resource(resource_name).call(action_name, params, http_headers, apipie_options)
  end

  # Creates a hash with IDs mapping to names for an array of records
  def id_name_map(records)
    records.inject({}) do |map, record|
      map.update(record['id'] => record['name'])
    end
  end

  #---
  #--- Get list of existing organizations
  orgs = call_api(:organizations, :index)
  org_list = id_name_map(orgs['results'])
  # Check if hash contains our organization
  if !org_list.has_value?(org_name)
    puts "Cannot find #{org_name}"
  else
    org_id = org_list.key(org_name)
  end
  #---
  # get hosts
  contenthosts = call_api(:hosts, :index, {'organization_id' => org_id})
  cHosts_list = id_name_map(contenthosts['results'])
#  p JSON.parse(contenthosts.to_s)
#  p contenthosts['results'].inspect
#  p cHosts_list.inspect

#  cHosts_list.map { |id,name| puts "#{id} #{name}" }

  cHosts_list.map do |id,name|
    puts id
    subscriptions = call_api(:subscriptions, :get, {'host_id' => id})
    p subscriptions.inspect
  end
  # use host id to extract subscriptions
#  cHosts_list.key.each do |id,name|
#    puts id
    #subscriptions = call_api(:subscriptions, :get, id)
    #puts subscriptions
#  end

  # ---
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

