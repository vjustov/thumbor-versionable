require 'spec_helper'

describe Versionable::Version do
  let(:version) do
    described_class.new OpenStruct.new(
      url: 'https://s3.amazonaws.com/ksr/assets/moo.png'
    ), width: 100, height: 150 do
      crop from: { x: 10, y: 35 }, to: { x: 34, y: 50 }
    end
  end

  it 'respond to :url' do
    expect(version).to respond_to(:url)
  end

  it 'constructs the url' do
    expect(version.url).to eq(
      'http://thumbor_server.net/FxHmUkBMExDwP5U6Ik00YrKMlKA=/10x35:' \
      '34x50/100x150/https://s3.amazonaws.com/ksr/assets/moo.png'
      )
  end

  context 'when the image is valid' do
    it 'correctly calculate it metadata' do
      expect(version.calculate_metadata).to eq(
        width: 100, height: 150
        )
    end
  end
end
