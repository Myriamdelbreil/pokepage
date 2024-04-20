# frozen_string_literal: true

require 'httparty'

module ApiConsumer
  class Client
    def initialize(url)
      @url = url
    end

    def fetch_data
      ::HTTParty.get(@url)
      # to implement later: raise an error if response isn't 200 with an accurate message and accurate class
    end
  end
end
