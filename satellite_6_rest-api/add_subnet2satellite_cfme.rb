#!/usr/bin/env ruby

require 'rest-client'
require 'json'

  url = 'https://sat6host.some.domain/api/'
  katello_url = "https://sat6host.some.domain/katello/api/v2/"
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
  # Get list of all subnets
  subnets = get_json("#{url}/organizations/#{org_id}/subnets")
  # declare array to store all subnets network address, e.g. "10.249.139.0/25"
  subnets_network = Array.new
  subnets['results'].map do |element|
    subnets_network << element['network']
  end

begin
#  subnets_list.map { |id,name,network| puts "#{id} #{name} #{network}" }
#    puts "There are #{subnets_list.length} subnets"
#  end
  subnets_list.each do |id,name,network|
     print id.to_s + " " + name + " " + network + "\n"
  end
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

