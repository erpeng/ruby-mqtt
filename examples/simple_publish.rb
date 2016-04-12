#!/usr/bin/env ruby
#
# Connect to a MQTT server, send message and disconnect again.
#

$:.unshift File.dirname(__FILE__)+'/../lib'

require 'rubygems'
require 'mqtt'

client=MQTT::Client.connect('localhost',:client_id=>"rubyhello")
client.publish('test', "The time is: #{Time.now}",false,1)

sleep 1000
