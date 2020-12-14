#!/usr/bin/env ruby
require "xmlrpc/client"
@SATELLITE_URL = "http://sat5host.some.domain/rpc/api"
@SATELLITE_LOGIN = "sat5user"
@SATELLITE_PASSWORD = "changeme"

@client = XMLRPC::Client.new2(@SATELLITE_URL)
@key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
#channels = @client.call('channel.listAllChannels', @key)
channel = "tec-x86_64-server-software-dev-7"

package_list = @client.call('packages.search.advancedWithChannel', @key, "name:AOL AND version:3.7.2.1", channel)
#package_list = @client.call('channel.software.listAllPackages', @key, channel, "2016-12-20 08:00:00")
for package in package_list do
  puts "#{package["name"]} #{package["version"]} #{package["release"]} #{package["id"]}"
  #details= @client.call('packages.getDetails', @key, package["id"])
  #puts details["size"]
  url = @client.call('packages.getPackageUrl', @key, package["id"] )
  puts url
end
@client.call("auth.logout", @key)

