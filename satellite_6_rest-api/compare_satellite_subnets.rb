#!/usr/bin/env ruby

require 'rest-client'
require 'json'
begin
  url1 = 'https://sat6host.some.domain/api/'
  $username1 = 'sat6user'
  $password1 = 'changeme'
  org_name1 = "ORG"
  org_id1 = 1

  # Performs a GET using the passed URL location
  def get_json(location)
      response = RestClient::Request.new(
          :method => :get,
          :url => location,
          :user => $username1,
          :password => $password1,
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
  subnets = get_json("#{url1}/organizations/#{org_id1}/subnets")
  subnets_list = id_name_map(subnets['results'])

  file1=File.open("/tmp/subnets_sat6host.txt","w")
  #subnets_list.map { |id,name| file1.puts "#{name}" }
  subnets_list.map{ |id,name| file1.puts "#{name}" }
  file1.close 
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

################################################################
#
begin
  url2 = 'https://sat6host2.some.domain/api/'
  $username2 = 'sat6user'
  $password2 = 'changeme'
  org_name2 = "ORG"
  org_id2 = 1

  # Performs a GET using the passed URL location
  def get_json(location)
      response = RestClient::Request.new(
          :method => :get,
          :url => location,
          :user => $username2,
          :password => $password2,
          :headers => { :accept => :json,
          :content_type => :json,
          :params => { "page" => 1, "per_page" => 1000 }
         }
      ).execute
      results = JSON.parse(response.to_str)
  end

  # ---------------------------------------------  #
  subnets2 = get_json("#{url2}/organizations/#{org_id2}/subnets")
  subnets2_list = id_name_map(subnets2['results'])
  subnets2_list.inspect
  #subnets_list2.sort! 
  file2=File.open("/tmp/subnets_sat6host2.txt","w")
  #subnets_list2.map { |id,name| file2.puts "#{name}" }
  subnets2_list.map{ |id,name| file2.puts "#{name}" }
  file2.close
  # --------------------------------------------  #
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end


# Diff files, output lines missing in file 2

f1 = File.open('/tmp/subnets_sat6host.txt')
f2 = File.open('/tmp/subnets_sat6host2.txt')

file1lines= f1.readlines
file2lines= f2.readlines

#puts "subnets in  sat6host #{file1lines.count}"
#puts "subnets in  sat6host2 #{file2lines.count}"
puts "#{file1lines.count.to_i - file2lines.count.to_i} missing subnets in segotl4385"
puts

f3 = File.open("/tmp/subnets_not_in_sat6host2.txt","w")

file1lines.each do |e|
  if(!file2lines.include?(e))
    f3.puts e
    puts e
  end
end

if(!File.zero?("/tmp/subnets_not_in_sat6host2.txt"))
  puts "cat /tmp/subnets_sat6host2.txt for missing subnets"
end

f1.close
f2.close
f3.close
