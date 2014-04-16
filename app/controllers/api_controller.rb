class ApiController < ApplicationController
  before_filter :check_payment_origin_server
  before_filter :check_payment_status, only: :new
  before_filter :check_payment_signature

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
    unless payment_class.valid_server?(request.remote_ip)
      render text: 'Error: Access denied', status: :forbidden
      return false
    end
  end

  def payment
    @payment ||= payment_class.new(params)
  end

  # Child classes will have their 'specific' payment
  # types to be processed. So we must set them in each
  # of such controllers.
  def payment_class
    raise NotImplementedError
  end
end
