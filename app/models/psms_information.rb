# encoding: UTF-8
require 'open-uri'

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
    @promotional_texts ||= extract_promotional_texts.with_indifferent_access
  end

  # Returns Array.
  #
  # Example:
  #   ['Estonia', 'Ukraine']
  def country_names
    @countries ||= countries.collect { |country| country['name'] }
  end

  # Returns Hash.
  #
  # Example:
  #   {
  #    "Estonia" => {
  #      "shortcode" => "1234",
  #        "keyword" => "TXT BADNEWS"
  #    }
  #  }
  def payment_details
    @payment_details ||= extract_payment_details.with_indifferent_access
  end

  private

  # Initialize new instance
  # with URL to the PSMS information XML file.
  def initialize(xml_data)
    @data = Hash.from_xml(xml_data)
  end

  def countries
    @data['services_api_response']['service']['countries'].values
  end

  def extract_promotional_texts
    countries.inject({}) do |memo, country|
      memo.merge!({
        country['name'] => country['promotional_text']
      })
    end
  end

  def extract_payment_details
    countries.inject({}) do |memo, country|
      memo.merge!({
        country['name'] => country['prices'].values.first['message_profile'].slice('shortcode', 'keyword')
      })
    end
  end
end
