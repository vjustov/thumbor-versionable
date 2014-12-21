require 'spec_helper'

describe Versionable::Version do
  let(:version) do
    described_class.new OpenStruct.new(
      url: 'https://s3.amazonaws.com/ksr/assets/moo.png'
      ), width: 100, height: 150
  end

  it 'should responds to :url' do
    expect(version).to respond_to(:url)
  end

  it 'should correctly constructs the url' do
    expect(version.url).to eq(
      'http://thumbor_server.net/pzNWZlQuWGNjwy2Ix-83Nc4gswY=/100' \
      'x150/https://s3.amazonaws.com/ksr/assets/moo.png'
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
