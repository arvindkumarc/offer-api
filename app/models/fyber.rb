class Fyber
  def get_offers
    HTTParty.get 'http://www.google.com', {query: {q: 'abc', output: 'json'}}
    %w(a b)
  end
end