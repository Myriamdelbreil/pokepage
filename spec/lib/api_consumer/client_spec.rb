# frozen_string_literal: true

require 'rails_helper'

describe ::ApiConsumer::Client, type: :service do
  subject { described_class.new(url).fetch_data }

  let(:url) { 'https://pokeapi.co/api/v2/pokemon' }

  it 'calls HTTParty gem' do
    expect(::HTTParty).to receive(:get).with(url)
    subject
  end
end
