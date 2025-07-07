class EcosystemsApiClient
  def self.connection(url)
    Faraday.new(url: url) do |faraday|
      faraday.headers['User-Agent'] = 'ruby.ecosyste.ms'
      faraday.response :follow_redirects
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.get(url)
    conn = connection(url)
    conn.get
  end
end