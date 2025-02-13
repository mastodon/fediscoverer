class HashtagUsage < ApplicationRecord
  belongs_to :content_object
  belongs_to :hashtag

  before_destroy do
    puts "AAAAAH!!!!!"
  end
end
