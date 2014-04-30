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
  p "#{Time.now.getutc} - Set #{name} with version #{version}"
  jsonFile = File.read("assets/#{name}.json")
  json = JSON.parse(jsonFile)
  if json['version'] then
    set_version = json['version']
    if set_version.to_i < version.to_i then
      redirect "/set/#{name}"
    end
    "No changes in set"
  else
    "Set does not have a version"
  end
end
