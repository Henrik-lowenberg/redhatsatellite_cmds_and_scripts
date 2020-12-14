#!/usr/bin/env ruby

require 'rest-client'
require 'json'
begin
  url = 'https://sat6host.some.domain/api/'
  katello_url = "https://sat6host.some.domain/katello/api/v2/"
  capsule1_url = "https://sat6capsule.some.domain:8443/api/v2/"
  $username = 'apiuser'
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
          :content_type => :json,
          :params => { "page" => 1, "per_page" => 1000 }
         }
      ).execute
      results = JSON.parse(response.to_str)
  end

  def id_name_map(records)
    records.inject({}) do |map, record|
      map.update(record['id'] => record['title'])
    end
  end

  # ---------------------------------------------  #
  # Get list of organization's lifecycle environments
  hostgroups = get_json("#{url}/organizations/#{org_id}/hostgroups")
#  p hostgroups.inspect
#  p hostgroups
#  exit
  hostgroups_list = id_name_map(hostgroups['results'])
#  prior_env_id = hostgroups_list.key("Library") 

  puts "There are #{hostgroups_list.length} hostgroups"
   hostgroups_list.each do |id,e|
    print " " + e + "\n"
  end
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

