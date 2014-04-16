require 'spec_helper'

describe 'Show News, User bought' do
  let(:current_user_id) { 1 }
  let(:current_user) { OpenStruct.new(id: current_user_id) }

  before do
    allow(User).to receive(:find).with(current_user_id.to_s).and_return(current_user)
  end

  context 'authenticated' do
    before do
      3.times do |i|
        news = News.create!(body: "News #{i}")
        UserNews.create!(user_id: current_user.id, news: news)
      end
    end
    it "displays User's News" do
      visit '/news?' + {user_id: current_user_id}.to_param

      expect(page).to have_content('News 0')
      expect(page).to have_content('News 1')
      expect(page).to have_content('News 2')
    end
  end

  context 'unauthenticated' do
    let(:current_user) { nil }

    it "displays error" do
      visit '/news?' + {user_id: current_user_id}.to_param

      expect(page).to have_content('Error: Access denied')
    end
  end
end
