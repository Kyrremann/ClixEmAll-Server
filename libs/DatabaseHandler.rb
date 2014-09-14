def save_to_cloudant(json)
  begin
    @respons =  JSON.parse(RestClient.post("#{$DB_URL}/sets/", json, {:content_type => :json, :accept => :json}))
    if @respons["ok"] then
      p "OK"
      p @respons
      p @respons["rev"]
      p @respons["id"]
      return @respons["rev"], @respons["id"]
    else
      # something bad :\
    end
  rescue => e
    p e.response
    # inform someone
  end
end

def load_from_cloudant(set)
  JSON.parse(RestClient.get($DB_URL + "/sets/#{set}"))
end

def get_list_of_sets()
  JSON.parse(RestClient.get($DB_URL + "/sets/0093c7f10ee8390c39eef23d837dce58"))
end

def save_list_of_sets(sets)
  begin
    @respons =  JSON.parse(RestClient.post("#{$DB_URL}/sets/", sets, {:content_type => :json, :accept => :json}))
    if @response["ok"] then
      sets["rev"] = @respons["rev"]
    else
      # something bad :\
    end
  rescue => e
    p e.response
    # inform someone
  end
end