#!/usr/bin/env ruby

require 'optparse'
require 'yaml'
require 'apipie-bindings'
require 'time'

@defaults = {
  :noop      => false,
  :uri       => 'https://sat6host.some.domain/',
  :user      => 'sat6user',
  :pass      => 'changeme',
  :timeout   => 300,
  :org       => 1,
  :ignore    => [],
  :age       => 90*24*60*60,
}

@options = {
  :yamlfile  => 'sat6_hostlist.yaml',
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{opts.program_name} [options]"
  opts.version = "0.1"

  opts.on("-U", "--uri=URI", "URI to the Satellite") do |u|
    @options[:uri] = u
  end
  opts.on("-t", "--timeout=TIMEOUT", OptionParser::DecimalInteger, "Timeout value in seconds for any API calls. -1 means never timeout") do |t|
    @options[:timeout] = t
  end
  opts.on("-u", "--user=USER", "User to log in to Satellite") do |u|
    @options[:user] = u
  end
  opts.on("-p", "--pass=PASS", "Password to log in to Satellite") do |p|
    @options[:pass] = p
  end
  opts.on("-o", "--organization-id=ID", "ID of the Organization") do |o|
    @options[:org] = o
  end
  opts.on("-c", "--config=FILE", "configuration in YAML format") do |c|
    @options[:yamlfile] = c
  end
  opts.on("-n", "--noop", "do not actually execute anything") do
    @options[:noop] = true
  end
end
optparse.parse!

@yaml = YAML.load_file(@options[:yamlfile])

if @yaml.has_key?(:settings) and @yaml[:settings].is_a?(Hash)
  @yaml[:settings].each do |key,val|
    if not @options.has_key?(key)
      @options[key] = val
    end
  end
end

@defaults.each do |key,val|
  if not @options.has_key?(key)
    @options[key] = val
  end
end

@ignoreregex = []
@options[:ignore].each do |i|
  @ignoreregex << Regexp.new(i)
end
puts "Starting function hostlist"
def hostlist()
  api = ApipieBindings::API.new({:uri => @options[:uri], :username => @options[:user], :password => @options[:pass], :api_version => '2', :timeout => @options[:timeout]})

  req = api.resource(:home).call(:status)
  if Gem::Version.new(req['version']) >= Gem::Version.new('1.11')
    @host_resource = :hosts
  else
    @host_resource = :systems
  end

#  puts "Variable declaration"
  systems = []
  unique_systems = {}
#  dropped_systems = []
  page = 0
  req = nil
  now = Time.now()
  # we could make this faster if we add ":search => 'lastCheckin:<=$(date -I -d '90 days ago')'" here
  # but then we would miss the most duplicates
  while (page == 0 or req['results'].length == req['per_page'].to_i)
    page += 1
    req = api.resource(@host_resource).call(:index, {:organization_id => @options[:org], :page => page, :per_page => 100})
    systems.concat(req['results'])
  end
  # Create log file
  out_file = File.new("satellite6_hostlist.txt", "w")
  #p systems.inspect
  systems.each do |system|
    out_file.puts "#{system['name']}, #{system['installed_at']}, #{system['subscription_status_label']}, #{system['model_name']}" 
  end
  out_file.close
end

hostlist
#puts "Ending function hostlist"
