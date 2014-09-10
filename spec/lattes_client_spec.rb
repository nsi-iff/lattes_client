require 'spec_helper'

describe LattesClient do
  before :all do
    port = 7888
    @client = LattesClient::Client.new(
      host: 'localhost', port: port, path: 'lattes')
    @server = LattesClient::FakeServer.new.start(port)
  end

  after :all do
    @server.stop
  end

  it 'gets an CNPq id given a CPF' do
    expect(@client.id_by_cpf('12345678909')).to eq '1234567890123456'
  end
end
