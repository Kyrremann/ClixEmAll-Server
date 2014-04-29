require 'sinatra'
require 'rubygems'
require 'git'
require 'logger'
require 'json'

get '/' do
  "Hello, world"
end

get '/set/:name' do | name |
  # push JSON set to user
  p "#{Time.now.getutc} - Sending file #{name}.json"
  send_file "assets/#{name}.json"
end

get '/set/:name/:version' do | name, version |
  # Check to see if version is lower then set's version
  # if it is push set to user, else eror or just a blank page
  "Hello #{name} with #{version}!"
end
