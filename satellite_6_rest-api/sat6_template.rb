#!/usr/bin/env ruby

require 'rest-client'
require 'json'
begin
  url = 'https://sat6host.some.domain/api/v2/'
  katello_url = "https://sat6host.some.domain/katello/api/v2/"
  capsule1_url = "https://sat6capsule.some.domain:8443/api/v2/"
  $username = 'sat6user'
  $password = 'changeme'
  org_name = "ORG"
  org_id = 1
  # puppet_environments = [ "dev", "qa", "prod" ]

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

  # ---------------------------------------------  #
  # Get list of organization's lifecycle environments
  envs = get_json("#{katello_url}/organizations/#{org_id}/environments")
  env_list = id_name_map(envs['results'])
  prior_env_id = env_list.key("Library") 

  puts "There are #{env_list.length} environments"
   env_list.each do |id,e|
    print " " + e + "\n"
  end
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

