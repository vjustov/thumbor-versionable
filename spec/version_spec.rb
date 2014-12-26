require 'spec_helper'

describe Versionable::Version do
  let(:version_full) do
    described_class.new OpenStruct.new(
      url: 'https://s3.amazonaws.com/ksr/assets/moo.png'
    ), width: 100, height: 150 do
      crop from: { x: 10, y: 35 }, to: { x: 34, y: 50 }
      horizontal_align :center
      vertical_align :top
    end
  end

  let(:version_empty) do
    described_class.new OpenStruct.new(
      url: 'https://s3.amazonaws.com/ksr/assets/moo.png'
    ), {}
  end

  it 'respond to :url' do
    expect(version_full).to respond_to(:url)
    expect(version_empty).to respond_to(:url)
  end

  it 'constructs the url' do
    expect(version_empty.url).to eq('http://thumbor_server.net/' \
      'rJFxkUxO6j6rXB3HpjAQN2nNS0g=/0x0/https://s3.amazonaws.co' \
      'm/ksr/assets/moo.png'
      )

    expect(version_full.url).to eq(
      'http://thumbor_server.net/2k_eIg_cVtazzmoB3o_8q4hUlx0=/10x35:' \
      '34x50/100x150/center/top/https://s3.amazonaws.com/ksr/assets/' \
      'moo.png'
      )
  end

  context 'when the image is valid' do
    it 'correctly calculate it metadata' do
      expect(version_full.calculate_metadata).to eq(
        width: 100, height: 150
        )
    end
  end
end
