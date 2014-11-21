class Topic < ActiveRecord::Base
  attr_accessible :forum_id, :user_id, :name, :created_at, :updated_at, :posts_count
  belongs_to :forum, :counter_cache => true
  belongs_to :user
  has_many   :posts, :dependent => :delete_all

  validates :name, :presence => true, :length => { :maximum => 255 }
end
