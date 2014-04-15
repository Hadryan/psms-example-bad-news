require 'spec_helper'

describe 'Front page' do
  let(:service_info_xml) { File.read(File.join(Rails.root, 'spec', 'assets', 'service.information.xml')) }

  before do
    FakeWeb.register_uri(:get, Rails.application.secrets.psms_info_url, body: service_info_xml)
  end

  it 'has proper SMS information' do
    visit '/'
    expect(page).to have_content 'Klienditugi: +372 5 111 11 11 | bofh@example.com'
    expect(page).to have_content 'Hind: €0.32'
    expect(page).to have_content 'Support: +372 5 111 11 11 | bofh@example.com'
    expect(page).to have_content 'Price: €0.32'
  end
end
