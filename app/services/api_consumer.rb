require 'httparty'

class ApiConsumer
  include HTTParty

  def initialize(url)
    @url = url
  end

  def call
    ::HTTParty.get(@url)
  end
end
