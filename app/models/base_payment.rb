require 'digest/md5'

# Base class for different types of mobile payments
class BasePayment

  # Set of valid HTTP request parameters. To be specified in
  # child classes.
  mattr_accessor :valid_request_params

  FORTUMO_SERVERS = %w{54.72.6.126 54.72.6.27 54.72.6.17 54.72.6.23
                       79.125.125.1 79.125.5.205 79.125.5.95}.freeze

  class << self
    # Create MD5 digest from a string, based on sorted and concatinated
    # request parameters&values.
    #
    # Required for Fortumo messages signature verification.
    #
    # See 'Signature' section at http://developers.fortumo.com/security/
    def sign(params)
      Digest::MD5.hexdigest(
        params.with_indifferent_access.reject {|k,v| v.nil?}.except(:sig).
          sort.map { |pair| pair.join('=')}.join +
              secret
      )
    end

    # Check if IP is included into white list
    # of Fortumo servers
    def valid_server?(ip)
      FORTUMO_SERVERS.include?(ip)
    end

    private

    def secret
      raise NotImplementedError
    end
  end

  def successful?
    raise NotImplementedError
  end

  def is_status_failed?
    raise NotImplementedError
  end

  def is_status_ok?
    raise NotImplementedError
  end

  def failed?
    not successful?
  end

  def signature_valid?
    @params[:sig] == signature
  end

  def is_test_mode?
    !!@params[:test]
  end

  private

  def initialize(params)
    @params = params.slice(*self.class.valid_request_params)
  end

  def signature
    self.class.sign(@params)
  end
end
