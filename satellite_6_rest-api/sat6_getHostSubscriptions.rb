#!/usr/bin/env ruby
# # Description: extracts all host IDs then maps
#   hostnames with their current subscriptions
#
require 'rest-client'
require 'json'

begin
  url = 'https://sat6host.some.domain/api/v2/'
  katello_url = "https://sat6host.some.domain/katello/api/v2/"
 
  capsule1_url = "https://sat6capsule.some.domain:8443/api/v2/"
  $username = 'apiuser'
  $password = 'redhat123'
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
#          :timeout => -1,
          :headers => { :accept => :json,
          :content_type => :json ,
#          :params => { "page" => 1, "per_page" => 1000 }}
      }
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
  # --------------------------------------------  #  
  contenthosts = get_json("#{url}/hosts") 
#  p contenthosts.inspect
  cHosts = id_name_map(contenthosts['results'])
  puts "Hostname; Customer; Subscription ID; Subscription Name; Subscription start date; Subscription end date; product ID; is guest using a hypervisor subscription"
  cHosts.map do |id,name| 
    print "#{name}; " 

#   Get all hosts subscriptions
    hostSubs = get_json("#{url}/hosts/#{id}/subscriptions")

### get hosts ENC variables
    hostEncs = get_json("#{url}/hosts/#{id}/enc")

    # loop through 2nd hash & extract customer ENC
    hostEncs['data']['parameters'].each do |enc|
      if enc.is_a?(::Array)
        #
        if enc.first =~ /customer/
          print "#{enc[1]}; "
        end
      end
    end
###   
   
#   get host subscriptions
    hostSubs['results'].each do |results|
      print "#{results['id']}; #{results['name']}; #{results['start_date']}; #{results['end_date']}; #{results['product_id']}; #{results['virt_who']}; "
    end
    
    puts
  end
#  p var.inspect
#  p var.class
#  p var.length
  # --------------------------------------------  #  

rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

