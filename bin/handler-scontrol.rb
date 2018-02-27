#!/usr/bin/env ruby

require "sensu-handler"
require "net/http"

class Scontrol < Sensu::Handler

  option :short_hostname,
        description: 'tell scontrol to use short hostnames instead of fqdn',
        short: '-s',
        long: '--short-hostname',
        default: ''

  option :binary_path,
        description: 'provide the path to the scontrol binary',
        short: '-p',
        long: '--path /opt/slurm/bin/scontrol',
        default: '/bin/scontrol'

  # this method will get events listed for the client that triggered this handler
  # it uses the settings from the api.json file configured in sensu to get credentials
  # it then gets a request from the api of all events, if any, and returns them as a string
  def event_exists?(client)
    api = @settings['api'] || {}
    path = "/events/#{client}"
    request = Net::HTTP::Get.new(path)
    if api['user']
      request.basic_auth(api['user'], api['password'])
    end
    Net::HTTP.new(api['host'] || '127.0.0.1', api['port'] || 4567).start do |http|
      response = http.request(request)
      response.body
    end
  end

  # search the event data for references to our variable from the check
  # definition called handled_by_scontrol.
  # this will return the number of occurences of "handled_by_scontrol"
  def handled_by_scontrol_count(client)
    event_exists?(client).scan(/handled_by_scontrol/).count
  end

  def handle

    # these variables are pulled from the @event data that this handler received:
    client = @event['client']['name']
    hostname= client.split('.')
    check = @event['check']['name']
    check_status = @event['check']['status']
    action = @event['action']

    if config[:short_hostname]
      if check_status != 0 && action == "create" && handled_by_scontrol_count(client) == 1
        system("sudo #{config[:binary_path]} update nodename=#{hostname.first} state=drain reason=\"sensu #{check}\"")
        puts "running: #{config[:binary_path]} update nodename=#{hostname.first} state=drain reason=\"sensu #{check}\""
      elsif check_status == 0 && action == "resolve" && handled_by_scontrol_count(client) == 0
        system("sudo #{config[:binary_path]} update nodename=#{hostname.first} state=undrain")
        puts "running: #{config[:binary_path]} update nodename=#{hostname.first} state=undrain"
      end
    else
      if check_status != 0 && action == "create" && handled_by_scontrol_count(client) == 1
        system("sudo #{config[:binary_path]} update nodename=#{hostname} state=drain reason=\"sensu #{check}\"")
        puts "running: #{config[:binary_path]} update nodename=#{hostname} state=drain reason=\"sensu #{check}\""
      elsif check_status == 0 && action == "resolve" && handled_by_scontrol_count(client) == 0
        system("sudo #{config[:binary_path]} update nodename=#{hostname} state=undrain")
        puts "running: #{config[:binary_path]} update nodename=#{hostname} state=undrain"
      end
    end
  end
end
