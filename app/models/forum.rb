class Forum < ActiveRecord::Base
  attr_accessible :name, :description, :created_at, :updated_at, :topics_count
  has_many :topics, :dependent => :delete_all
  has_many :posts,  :through => :topics

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :description, :length => { :maximum => 1000 }
end
