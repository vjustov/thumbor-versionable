require 'spec_helper'

describe Versionable::Configuration do
  let(:config) do
    described_class.new do
      thumbor_server('server_test.example.com')
      secret_key('S3CR37_K3Y!!')
    end
  end

  it 'correctly set the server' do
    expect(config.thumbor_server).to eq('server_test.example.com')
  end
  it 'correctly set the secret_key' do
    expect(config.secret_key).to eq('S3CR37_K3Y!!')
  end
end
