class NewsController < ApplicationController
  before_filter :authenticate_user

  def index
    @news = News.joins(:user_news).where(user_news: {user_id: current_user.id})
  end

  def current_user
    @current_user ||= User.find(params[:user_id])
  end
  helper_method :current_user

  private

  def authenticate_user
    if current_user.nil?
      render text: 'Error: Access denied', status: :forbidden
      return false
    end
  end
end
