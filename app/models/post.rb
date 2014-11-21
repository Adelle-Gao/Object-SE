class Post < ActiveRecord::Base
  attr_accessible :topic_id, :user_id, :body, :created_at, :updated_at
  belongs_to :topic, :counter_cache => true
  belongs_to :user, :counter_cache => true

  validates :body, :presence => true, :length => { :maximum => 10000 }
end
