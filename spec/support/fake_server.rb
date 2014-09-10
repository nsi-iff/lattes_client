module LattesClient
  class FakeServer
    def start(port)
      queue = Queue.new
      @thread = Thread.new { FakeApp.run!(port: port) { queue.push('ok!') } }
      queue.pop # wait for fakeapp to start
      self
    end

    def stop
      @thread.kill
      self
    end
  end

  class FakeApp < Sinatra::Application
    get '/lattes/id' do
      content_type :json
      { id: '1234567890123456' }.to_json
    end

    get '/lattes/curriculo_compactado' do
      content_type :json
      encoded_zip = Base64.encode64(curriculum_zip)
      { curriculo: encoded_zip }.to_json
    end
  end
end
