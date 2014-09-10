require 'net/http'
require 'json'

module LattesClient
  class Client
    def initialize(options)
      @host, @port, @path, @ssl = options.values_at(:host, :port, :path, :ssl)
    end

    def id_by_cpf(cpf)
      response = execute_request(:id, cpf: cpf)
      response_hash = parse(response.body)
      response_hash['id']
    end

    private

    def parse(json_response)
      JSON.parse(json_response)
    end

    def execute_request(operation, params)
      Net::HTTP.start(@host, @port) do |http|
        request = Net::HTTP::Post.new(uri_for(operation))
        request.body = params.to_json
        http.request(request)
      end
    end

    def uri_for(operation)
      "#{schema}://#@host:#@port#{path}/#{operation}"
    end

    def path
      @path ? "/#{@path}" : ''
    end

    def schema
      @ssl ? 'https' : 'http'
    end
  end
end
