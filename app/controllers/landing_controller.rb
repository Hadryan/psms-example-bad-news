class LandingController < ApplicationController
  def index
    @promotional_texts = psms_info.promotional_texts
  end

  private

  def psms_info
    @@psms_info ||= PSMSInformation.find(Rails.application.secrets.psms_info_url)
  end
end
