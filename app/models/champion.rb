class Champion < ActiveRecord::Base

  def self.data
    api_key = ENV["LEAGUE_API_KEY"]
    lol_api_response = URI("https://na.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=#{api_key}
    ")

    response = Net::HTTP.get(lol_api_response)
    champ_data = JSON.parse(response)
    champions = champ_data["data"]
    ###########################
    ###Reorganize Data#########
    clean_data = Array.new
    champions.each do |key, value|
      clean_data << value
    end
    return clean_data
  end

end
