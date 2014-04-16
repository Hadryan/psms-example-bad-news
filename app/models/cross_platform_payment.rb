# Presents fact of user's payment via
# Fortumo Cross-Platform Mobile Payments API.
#
# See: http://developers.fortumo.com/mobile-payments-for-web-apps/
class CrossPlatformPayment < BasePayment
  class << self
    private

    def secret
      Rails.application.secrets.cross_platform_api.secret
    end
  end

  def successful?
    is_status_ok?
  end

  def is_status_failed?
    !!(@params[:status].to_s.downcase =~ 'failed')
  end

  def is_status_ok?
    @params[:status].to_s.downcase == 'completed'
  end

  def items_amount
    @params[:amount].to_i
  end

  def user_id
    @params[:cuid]
  end

  private

  def valid_request_params
    %w{amount country credit_name cuid
       currency operator payment_id price price_wo_vat
       revenue sender service_id sig status
       test user_share}.uniq
  end
end
