require 'net/http'
require 'json'
require 'base64'
require 'zip'

module LattesClient
  class Client
    def initialize(options)
      options = symbolize_keys(options)
      @host, @port, @path, @ssl = options.values_at(:host, :port, :path, :ssl)
    end

    def id_by_cpf(cpf)
      response = execute_request(:id, cpf: cpf)
      response_hash = parse(response.body)
      response_hash['id']
    end

    def curriculum(id)
      response = execute_request(:curriculo_compactado, id: id)
      response_hash = parse(response.body)
      zip_file = Base64.decode64(response_hash['curriculo'])
      extract_file(zip_file)
    end

    private

    def parse(json_response)
      JSON.parse(json_response)
    end

    def execute_request(operation, params)
      Net::HTTP.start(@host, @port) do |http|
        request = Net::HTTP::Get.new(uri_for(operation))
        request.body = params.to_json
        http.request(request)
      end
    end

    def extract_file(zip_content)
      stream = Zip::InputStream.open(StringIO.new(zip_content))
      result = []
      begin
        stream.get_next_entry
        result << stream.read.force_encoding('UTF-8')
      ensure
        stream.close
      end
      result[0]
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

    def symbolize_keys(hash)
      hash.reduce({}) do |h, (k, v)|
        h[k.to_sym] = v
        h
      end
    end
  end
end
