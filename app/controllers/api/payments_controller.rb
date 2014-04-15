class Api::PaymentsController < ApplicationController
  before_filter :check_payment_origin_server
  before_filter :check_payment_status, only: :new
  before_filter :check_payment_signature

  def new
    news = News.limit(1).order('RANDOM()').first
    render text: news.body
  end

  private

  def check_payment_status
    if payment.failed?
      render text: 'Error: Payment failed', status: :payment_required
      return false
    end
  end

  def check_payment_signature
    unless payment.signature_valid?
      render text: 'Error: Invalid signature', status: :not_found
      return false
    end
  end

  def check_payment_origin_server
    unless Payment.valid_server?(request.remote_ip)
      render text: 'Error: Access denied', status: :forbidden
      return false
    end
  end

  def payment
    @payment ||= Payment.new(params)
  end
end
