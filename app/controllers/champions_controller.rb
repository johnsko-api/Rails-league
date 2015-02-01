class ChampionsController < ApplicationController

def index
  binding.pry
@champions = Champion.data["name"]
end

end
