class Article < ActiveRecord::Base
  attr_accessible :content, :description, :status, :title, :user_id
end
