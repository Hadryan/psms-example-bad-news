# encoding: UTF-8
require 'spec_helper'

describe 'Front page' do
  let(:service_info_xml) { File.read(File.join(Rails.root, 'spec', 'assets', 'service.information.xml')) }

  before do
    FakeWeb.register_uri(:get, Rails.application.secrets.mobile_api.psms_info_url, body: service_info_xml)
  end

  describe 'News to Phone' do
    it 'has proper SMS information' do
      visit '/'
      expect(page).to have_content 'Klienditugi: +372 5 111 11 11 | bofh@example.com'
      expect(page).to have_content 'Hind: €0.32'
      expect(page).to have_content 'Support: +372 5 111 11 11 | bofh@example.com'
      expect(page).to have_content 'Price: €0.32'
    end

    it 'has instructions where to send SMS' do
      visit '/'
      expect(page).to have_content 'TXT BADNEWS'
      expect(page).to have_content '1311'
    end
  end

  describe 'News on Web Page' do
    let(:current_user) { OpenStruct.new(id: 1) }
    let(:service_id) { Rails.application.secrets.cross_platform_api.service_id }
    let(:rel) { [service_id, current_user.id].join('/') }

    before  do
      allow(User).to receive_message_chain(:all, :sample).and_return(current_user)
    end

    it 'has 1-Click button with proper rel including service_id and current user_id' do
      visit '/'
      expect(page).to have_css(%Q{a[id="fmp-button"][rel="#{rel}"]})
    end
  end
end
