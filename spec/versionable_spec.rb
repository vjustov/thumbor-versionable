require 'spec_helper'

describe Versionable do

  Versionable.configure do
    thumbor_server 'http://thumbor_server.net'
  end

  class FakeClass
    include Versionable

    versionable :image, :external_fake_image do
      version :form_thumbnail, width: 100, height: 150 do
        filter :quality, 50
      end
      version :form_thumbnail_2, width: 100, height: 150
    end
  end

  let(:fake_product) do
    fake_product = FakeClass.new
    allow(fake_product).to receive(:external_fake_image) do
      'http://google.com/favicon.ico'
    end
    fake_product
  end

  it 'adds :versionable to the class' do
    expect(FakeClass).to respond_to(:versionable)
  end

  it 'should responds to the method specified' do
    expect(fake_product).to respond_to(:image)
  end
end

