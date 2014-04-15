class LandingController < ApplicationController
  def index
    @countries         = psms_info.country_names
    @payment_details   = psms_info.payment_details
    @promotional_texts = psms_info.promotional_texts
  end

  private

  def psms_info
    @@psms_info ||= PSMSInformation.find(Rails.application.secrets.psms_info_url)
  end
end
