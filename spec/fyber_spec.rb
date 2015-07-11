require 'rails_helper'
require 'rake'

describe 'fyber' do
  it 'should make a call to offer api' do
    fyber = Fyber.new
    results = %w(a b)

    expect(HTTParty).to receive(:get).with('http://www.google.com',
             :query => { :q => 'abc', :output => 'json' }).and_return(results)

    expect(fyber.get_offers).to match_array(results)
  end
end