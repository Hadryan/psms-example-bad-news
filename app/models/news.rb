# Just a (bad) news entity in DB.
class News < ActiveRecord::Base
  has_many :user_news

  def self.find_random(count=1)
    limit(count).order('RANDOM()')
  end
end
