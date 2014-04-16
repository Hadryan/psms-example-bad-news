require 'spec_helper'
require 'rack/test'

describe 'Widget Payment' do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:remote_addr)   { BasePayment::FORTUMO_SERVERS.sample }
  let(:extra_headers) { {'REMOTE_ADDR' => remote_addr} }

  let(:request_params) do
    request_params_no_signature.merge(
      sig:  signature
    )
  end

  # We need them to create 'sig'(nature)
  let(:request_params_no_signature) do
    {
      amount:       amount,
      country:      country,
      credit_name:  credit_name,
      cuid:         current_user_id,
      currency:     currency,
      operator:     operator,
      payment_id:   payment_id,
      price:        price,
      price_wo_vat: price_wo_vat,
      revenue:      revenue,
      sender:       sender,
      service_id:   service_id,
      status:       status,
      test:         test,
      user_share:   user_share
    }
  end

  let(:amount)          { 4 }
  let(:country)         { 'EE' }
  let(:credit_name)     { 'News' }
  let(:current_user_id) { User.all.first.id }
  let(:currency)        { 'EUR' }
  let(:operator)        { '' }
  let(:payment_id)      { 'f61c0ca5a4dc1b221f96bf5d50610759' }
  let(:price)           { '1.6' }
  let(:price_wo_vat)    { '1.33' }
  let(:revenue)         { '0.67' }
  let(:sender)          { '37251234567' }
  let(:service_id)      { '2c05823798f034d648c9fd8e81b39a7c' }
  let(:signature)       { BasePayment.sign(request_params_no_signature) }
  let(:status)          { 'completed' }
  let(:test)            { nil } # 'ok' is possible
  let(:user_share)      { '0.5' }

  before do
    amount.times { |i| News.create!(body: "News #{i}") }
  end

  context 'successful' do
    it 'adds (amount) of random News to User account' do
      get '/api/widget_payments/new', request_params, extra_headers

      expect(last_response.status).to eq(200)
      expect(UserNews.where(user_id: current_user_id).count).to eq(amount)
    end
  end

  context 'failed' do
    let(:status) { 'mt_failed' }

    it 'adds (amount) of random News to User account' do
      get '/api/widget_payments/new', request_params, extra_headers

      expect(last_response.status).to eq(402)
      expect(last_response.body).to   eq('Error: Payment failed')
      expect(UserNews.count).to be_zero
    end
  end
end
