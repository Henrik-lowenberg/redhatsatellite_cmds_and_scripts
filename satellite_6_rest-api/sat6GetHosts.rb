#!/usr/bin/tfm-ruby
# Created 2019-03-07
# By: Henrik Lowenberg
# 
require 'apipie-bindings'
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

  ##########

  hosts = call_api(:hosts, :index)
  hostsList = id_name_map(hosts['results'])

  if hostsList.empty? 
    puts "No hosts found or something went wrong."
  else
    puts "Hosts found!"
    puts
    hostsList.each do |hostName|
      puts hostName
    end
  end

rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

