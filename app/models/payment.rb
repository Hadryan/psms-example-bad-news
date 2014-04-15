require 'digest/md5'

##
# Presents fact of user's payment for
# service provided by merchant to a carrier
class Payment

  REQUEST_PARAMS = %w{billing_type country currency keyword
                      message message_id operator price price_wo_vat
                      sender service_id shortcode sig status test}

  FORTUMO_SERVERS = %w{54.72.6.126 54.72.6.27 54.72.6.17 54.72.6.23
                       79.125.125.1 79.125.5.205 79.125.5.95}

  def self.sign(params)
    Digest::MD5.hexdigest(
      params.with_indifferent_access.reject {|k,v| v.nil?}.except(:sig).
        sort.map { |pair| pair.join('=')}.join +
            Rails.application.secrets.fortumo_secret
    )
  end

  def self.valid_server?(ip)
    FORTUMO_SERVERS.include?(ip)
  end

  def successful?
    is_mo? && is_status_ok? || is_mt? && !is_status_failed? || is_test_mode?
  end

  def failed?
    not successful?
  end

  def signature_valid?
    @params[:sig] == signature
  end

  def is_status_failed?
    @params[:status].to_s.downcase == 'failed'
  end

  def is_mo?
    @params[:billing_type].to_s.downcase == 'mo'
  end

  def is_mt?
    not is_mo?
  end

  def is_status_ok?
    @params[:status].to_s.downcase == 'ok'
  end

  def is_test_mode?
    !!@params[:test]
  end

  private

  def initialize(params)
    @params = params.slice(*REQUEST_PARAMS)
  end

  def signature
    self.class.sign(@params)
  end
end
