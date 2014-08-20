require 'sinatra'
require 'rubygems'
require 'haml'
require 'json'

get '/' do
  haml :index
end

get '/set/versions' do
  versions = "{"
  Dir.glob("assets/*.json") do | file |
    json = JSON.parse(File.read(file))
    filename = File.basename("#{file}", ".json")
    versions += "\"#{filename}\":#{json["version"]},"
  end
  
  versions = versions[0...-1]
  return versions += "}"
end

get '/set/:name' do | name |
  # push JSON set to user
  p "[#{Time.now.getutc}] - Sending file #{name}.json"
  send_file "assets/#{name}.json"
end

get '/set/:name/:version' do | name, version |
  # Check to see if version is lower then set's version
  # if it is push set to user, else eror or just a blank page
  p "[#{Time.now.getutc}] - Set #{name} with version #{version}"
  jsonFile = File.read("assets/#{name}.json")
  json = JSON.parse(jsonFile)
  if json['version'] then
    set_version = json['version']
    if set_version.to_i < version.to_i then
      redirect "/set/#{name}"
    end
    "No changes in set #{name}"
  else
    "#{name} does not have a version"
  end
end

get '/add/clix' do
  if params[:success] then
    haml :add_clix, :locals => {"success" => "Clix added"}
  else 
    haml :add_clix
  end  
end

post '/add/clix' do
  if params["set"] == "empty" || params["id"] == "" || params["name"] == "" || params["points"] == "" then
    haml :add_clix, :locals => params
  else
    filename = "assets/#{params["set"]}.json"
    jsonFile = File.read(filename)
    json = JSON.parse(jsonFile)
    json[params["id"]] = {:name => params["name"], :keywords => params["keywords"], :team_ability => params["ta"].split(","), :points => params["points"]}
    json["version"] = json["version"] + 1
    File.open(filename, 'w') do | output |
      output.write(JSON.generate(json))
    end
    redirect '/add/clix?success=true'
  end
end

def getSetSelect()
  titles = {}
  Dir.glob("assets/*.json") do | file |
    json = JSON.parse(File.read(file))
    filename = File.basename("#{file}", ".json")
    titles[filename] = json["set_title"]
  end

  titles
end
