require 'google/api_client'

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


  DEVELOPER_KEY = ENV["YOUTUBE_API_KEY"]
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def self.get_service
    client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => 'Johns APP',
    :application_version => '0.0.1'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end

  def self.get_url(clip)
    opts = Trollop::options do
      opt :q, '#{clip}', :type => String, :default => clip + 'champion spotlight'
      opt :max_results, 'Max results', :type => :int, :default => 1
    end

    client, youtube = Champion.get_service

    begin
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => opts[:q],
        :maxResults => opts[:max_results]
      }
      )

      videos = []
      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.
      search_response.data.items.each do |search_result|
        case search_result.id.kind
        when 'youtube#video'
          videos << "//youtube.com/embed/#{search_result.id.videoId}"
        end
      end
      url = videos[0]
      url
    end
  end


end
