require 'httparty'

class ApiConsumer
  include HTTParty

  URL = 'https://pokeapi.co/api/v2'

  def initialize(url_path)
    @url = URL + url_path
  end

  def call
    ::HTTParty.get(@url)
  end
end
