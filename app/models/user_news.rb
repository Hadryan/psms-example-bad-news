class UserNews < ActiveRecord::Base
  belongs_to :news

  def user
    User.find(user_id)
  end
end
