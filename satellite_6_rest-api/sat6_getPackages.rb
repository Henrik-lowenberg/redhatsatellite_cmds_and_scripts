#!/usr/bin/env ruby

require 'rest-client'
require 'json'

url = 'https://sat6host.some.domain/api/v2/'
katello_url = "https://sat6host.some.domain/katello/api/"
katello_url2 = "https://sat6host.some.domain/katello/api/v2/"
capsule1_url2 = "https://sat6capsule.some.domain:8443/api/v2/"
$username = 'sat6user'
$password = 'changeme'
org_name = "ORG"
org_id = 1

begin

  # Performs a GET using the passed URL location
  def get_json(location)
      response = RestClient::Request.new(
          :method => :get,
          :url => location,
          :user => $username,
          :password => $password,
          :timeout => -1,
          :headers => { :accept => :json,
          :content_type => :json ,
          :params => { "page" => 1, "per_page" => 25000 }}
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
  # Variable declaration part II
  # Content_views & their IDs
  #
  # 13,cv-rhel7
  # 27,cv-rhel6
  # 14,cv-epel_rhel7
  # 28,cv-epel_rhel6
  cvid = '13'
  cvs_with_rhel = Array.new
  # ---------------------------------------------  #
  # get list of all cvs & id
  cvs = get_json("#{katello_url}/content_views")
  cvs_list =  id_name_map(cvs['results'])
  cvs_list.each do |id,name|
    puts "ID: #{id.to_i}\t Name: #{name.to_s}"
    (cvs_with_rhel << id) if name.match(/"rhel"/)
  end
  puts "cvs_with_rhel id: "
  cvs_with_rhel.each {|id| puts id}
  puts cvs_with_rhel.length

  # get list of all repos for selected content_view
#  repos = get_json("#{katello_url}/content_views/#{cvid}/repositories")
#  repos = get_json("#{katello_url}/organizations/1/content_views/#{cvid}/repositories")
#  repos_list = id_name_map(repos['repositories'])
#  p repos_list.inspect

#  repos_list = id_name_map(repos['results'])
#  p repos_list.inspect
  #
  repo_id = '23'
  # ---------------------------------------------  #
  # Get list packages and their IDs
#  pkgs = get_json("#{katello_url}/repositories/#{repo_id}/packages")
#  p pkgs.inspect
#  pkgs_list = id_name_map(pkgs['results'])
  #p pkgs_list.inspect
=begin
  puts "There are #{pkgs_list.length} packages in this channel"
  pkgs_list.each do |id,pkg|
    puts " #{id.to_i} #{pkg.to_s}" 
  end
=end  
  # --------------------------------------------  #  
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end

