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
    post '/lattes/id' do
      content_type :json
      { id: '1234567890123456' }.to_json
    end
  end
end
