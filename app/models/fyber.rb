require 'net/http'
require 'cgi'

class Fyber
  API_KEY = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'

  def get_offers

    params = {appid: 157,
              uid: 'player1',
              format: 'json',
              device_id: '2b6f0cc904d137be2e1730235f5664094b83',
              locale: 'de',
              ip: '109.235.143.113',
              offer_types: 112,
              timestamp: DateTime.now.to_i}

    http_get('api.sponsorpay.com', '/feed/v1/offers.json', add_signature(query_params(params)))
  end

  def query_params(params)
    params.
        reject { |key, value| value.nil? }.
        sort.
        map { |key, value| "#{key}=#{value}" }.
        join('&')
  end

  def add_signature(params)
    hash = Digest::SHA1.hexdigest(params+ '&' + API_KEY)
    params.concat('&hashkey=').concat(hash)
  end

  def http_get(domain, path, params)
    Net::HTTP.get(domain, "#{path}?".concat(params))
  end
end