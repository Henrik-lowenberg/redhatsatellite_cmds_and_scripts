#!/usr/bin/env ruby

require "xmlrpc/client"

@SATELLITE_URL = 'https://sat5host.some.domain/api'
@SATELLITE_LOGIN = 'sat5user'
@SATELLITE_PASSWORD = 'changeme'

@client = XMLRPC::Client.new2(@SATELLITE_URL)

@key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
channels = @client.call('channel.listAllChannels', @key)
for channel in channels do
   p channel["label"]
end

@client.call('auth.logout', @key)
