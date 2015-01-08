require 'spec_helper'

describe Versionable::Image do
  let(:image) do
    described_class.new OpenStruct.new(
      url: 'https://s3.amazonaws.com/ksr/assets/moo.png'
      ), :url, :accessor do
      version :form_thumbnail, width: 100, height: 150 do
        filter :quality, 50
      end
      version :form_thumbnail_2, width: 100, height: 150
    end
  end

  it 'should responds to :url' do
    expect(image).to respond_to(:url)
    expect(image.url).to eq('https://s3.amazonaws.com/ksr/assets/moo.png')
  end

  it 'should responds to version' do
    expect(image).to respond_to(:form_thumbnail)
    expect(image).to respond_to(:form_thumbnail_2)
  end

  it 'should be rendered as a json' do
    expect(image).to respond_to(:to_json)
    expect(image.to_json).to eq(
      '{"url":"https://s3.amazonaws.com/ksr/assets/moo.png","form_thumbnail":' \
      '{"url":"http://thumbor_server.net/JCvCnwX3k3NBcHOF_HICTy9dEk8=/100x150' \
      '/filters:quality(50)/https://s3.amazonaws.com/ksr/assets/moo.png"},"fo' \
      'rm_thumbnail_2":{"url":"http://thumbor_server.net/pzNWZlQuWGNjwy2Ix-83' \
      'Nc4gswY=/100x150/https://s3.amazonaws.com/ksr/assets/moo.png"}}')
  end

  context 'when the image is valid' do
    let(:metadata) do
      {
        'thumbor' => {
          'operations' => [],
          'source' => {
            'url' => 'http://google.com/favicon.ico',
            'width' => 32,
            'height' => 32
          },
          'focal_points' => [{
            'origin' => 'alignment',
            'height' => 1,
            'width' => 1,
            'y' => 16.0,
            'x' => 16.0,
            'z' => 1.0
          }],
          'target' => { 'width' => 32, 'height' => 32 }
        }
      }
    end

    it 'should fetch the image metadata' do
      expect(image).to respond_to(:fetch_metadata)
    end

    it 'should be able to set height from the metadata' do
      expect(image.height_from_metadata metadata).to eq(32)
    end

    it 'should be able to set the width from the metadata' do
      expect(image.width_from_metadata metadata).to eq(32)
    end
  end

  context 'when the image is invalid' do
    let(:metadata) { '' }

    it 'setting the height from the metadata should throw an exception' do
      expect { image.height_from_metadata metadata }.to \
      raise_exception
    end
    it 'setting the width from the metadata should throw an exception' do
      expect { image.width_from_metadata metadata }.to \
      raise_exception
    end
  end
end
