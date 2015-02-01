class ChampionsController < ApplicationController

def index
  @champions = Champion.data
end

def show
  champ_id = params[:id].to_i
  clean_data = Champion.data
  @champ_info = clean_data.find {|f| f["id"] == champ_id}
  @url = Champion.get_url(@champ_info["name"])
end

end
