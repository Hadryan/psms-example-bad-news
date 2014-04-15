require 'spec_helper'
require 'rack/test'

describe 'Payment' do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:request_params) do
    request_params_no_signature.merge(
      sig:  signature
    )
  end

  # We need them to create 'sig'(nature)
  let(:request_params_no_signature) do
    {
      billing_type: billing_type,
      country:      country,
      currency:     currency,
      keyword:      keyword,
      message:      message,
      message_id:   message_id,
      operator:     operator,
      price:        price,
      price_wo_vat: price_wo_vat,
      sender:       sender,
      service_id:   service_id,
      shortcode:    shortcode,
      status:       status
    }
  end

  let(:billing_type)  { 'MO' }
  let(:country)       { 'EE' }
  let(:currency)      { 'EUR' }
  let(:keyword)       { 'TXT BADNEWS' }
  let(:message)       { '' }
  let(:message_id)    { '15e817d93de341071a11bf4e17aac1bb' }
  let(:operator)      { 'Elisa' }
  let(:price)         { '0.32' }
  let(:price_wo_vat)  { '0.27' }
  let(:sender)        { '37256342863' }
  let(:service_id)    { '67324526784536747635672356723563' }
  let(:shortcode)     { '1311' }
  let(:signature)     { Payment.sign(request_params_no_signature) }
  let(:status)        { 'OK' }

  let!(:a_news) { News.create!(body: 'Foo bar.') }

  context 'successful' do
    context 'Mobile-Originated' do
      it 'sends a News entiry' do
        get '/api/payments/new', request_params
        expect(last_response.body).to eq(a_news.body)
      end
    end

    context 'Mobile-Terminated' do
      let(:billing_type) { 'MT' }
      let(:status)       { 'pending' }

      it 'sends a News entiry' do
        get '/api/payments/new', request_params
        expect(last_response.body).to eq(a_news.body)
      end
    end
  end

  context 'has not valid request' do
    let(:signature) { 'LOL!' }

    it 'returns no data' do
      get '/api/payments/new', request_params
      expect(last_response.status).to eq(404)
      expect(last_response.body).to   eq('Error: Invalid signature')
    end
  end

  context 'failed' do
    let(:status) { 'failed' }

    it 'returns no data' do
      get '/api/payments/new', request_params
      expect(last_response.status).to eq(402)
      expect(last_response.body).to   eq('Error: Payment failed')
    end
  end
end
