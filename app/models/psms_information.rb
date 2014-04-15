require 'open-uri'
require 'nokogiri'

##
# Class: PSMSInformation
#
# Loads and keeps information about
# Premium SMS from Fortumo API
# to show up-to-date phone numbers.
class PSMSInformation

  # Returns PSMSInformation instance with data populated from URL
  def self.find(url)
    raw_xml = open(url) {|f| f.read }
    new(raw_xml)
  end

  # Returns Hash.
  #
  # Example:
  #   {
  #   "Estonia" => {
  #     "local" => "Hind: €0.32\nKlienditugi: +372 5 111 11 11 | bofh@example.com\nSMS-ühendus: fortumo.ee",
  #     "english" => "Price: €0.32\nSupport: +372 5 111 11 11 | bofh@example.com\nMobile Payment by fortumo.com"
  #     }
  #   }
  def promotional_texts
    @promotional_texts ||= extract_countries(@data.xpath('//services_api_response/service/countries/*'))
  end

  private

  # Initialize new instance
  # with URL to the PSMS information XML file.
  def initialize(xml_data)
    @data = Nokogiri::XML.parse(xml_data)
  end

  def extract_countries(countries)
    countries.inject({}) do |memo, country|
      memo.merge!(
        {
          country['name'] => extract_languages(country.xpath('//promotional_text/*'))
        }
      )
    end
  end

  def extract_languages(langs)
    langs.inject({}) {|memo, lang| memo.merge!({lang.name => lang.text}) }
  end
end
