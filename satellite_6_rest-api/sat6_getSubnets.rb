#!/usr/bin/env ruby

require 'rest-client'
require 'json'
begin
  url = 'https://sat6host.some.domain/api/'
  katello_url = "https://sat6host.some.domain/katello/api/v2/"
  capsule1_url = "https://sat6capsule.some.domain:8443/api/v2/"
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
          :content_type => :json,
          :params => { "page" => 1, "per_page" => 1000 }
         }
      ).execute
      results = JSON.parse(response.to_str)
  end

  def id_name_map(records)
    records.inject({}) do |map, record|
      map.update(record['id'] => record['name'])
    end
  end

  # ---------------------------------------------  #
  # Get list of organization's lifecycle environments
  subnets = get_json("#{url}/organizations/#{org_id}/subnets")
#  p subnets.inspect
#  p subnets
#  exit
  subnets_list = id_name_map(subnets['results'])
# p subnets_list.inspect

  subnets_list.map { |id,name| puts "#{id} #{name}" }
  puts "There are #{subnets_list.length} subnets"
#   subnets_list.each do |id,name|
#    print id + " " + name + "\n"
#  end
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

