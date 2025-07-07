require "test_helper"

class EcosystemsApiClientTest < ActiveSupport::TestCase
  test "connection sets User-Agent header to ruby.ecosyste.ms" do
    url = 'https://example.com'
    connection = EcosystemsApiClient.connection(url)
    
    assert_equal 'ruby.ecosyste.ms', connection.headers['User-Agent']
  end
  
  test "get makes request with correct user-agent header" do
    url = 'https://packages.ecosyste.ms/api/v1/test'
    
    stub_request(:get, url)
      .with(headers: { 'User-Agent' => 'ruby.ecosyste.ms' })
      .to_return(status: 200, body: '{"test": "data"}')
    
    response = EcosystemsApiClient.get(url)
    
    assert_equal 200, response.status
    assert_equal '{"test": "data"}', response.body
  end
end