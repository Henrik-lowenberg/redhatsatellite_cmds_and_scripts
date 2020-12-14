#!/usr/bin/env ruby
require "xmlrpc/client"
require 'yaml'
require 'json'

begin
  @SATELLITE_URL = "http://sat5host.some.domain/rpc/api"
  @SATELLITE_LOGIN = "sat5user"
  @SATELLITE_PASSWORD = "changeme"
  @HOSTNAME = ARGV[0]

  if ARGV.empty? 
    puts "No hostname supplied!"
    puts "Exiting..."
    exit
  end
  @client = XMLRPC::Client.new2(@SATELLITE_URL)
  @sessionkey = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)

  # get the Id for a host
  @hostinfo = @client.call('system.getId',@sessionkey,@HOSTNAME)
#  puts @hostinfo.inspect
  puts @HOSTNAME
  @hostid = @hostinfo[0]['id'].to_i

  @host_base_channel = @client.call('system.getSubscribedBaseChannel',@sessionkey,@hostid)
#  puts @host_base_channel.inspect
  puts " #{@host_base_channel['name']}"

  @host_child_channel = @client.call('system.listSubscribedChildChannels',@sessionkey,@hostid)
#  puts @host_child_channel
  for childchannel in @host_child_channel
    puts " #{childchannel['name']}"
  end

  puts
# Logout from your session
#@client.call(@client.call,@sessionkey)

rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
end
