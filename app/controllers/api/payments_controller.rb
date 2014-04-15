class Api::PaymentsController < ApplicationController
  before_filter :check_payment_status, only: :new

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

  def payment
    @payment ||= Payment.new(params)
  end
end
