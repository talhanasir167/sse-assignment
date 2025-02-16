class Blog < ApplicationRecord
  belongs_to :user
  has_many :api_responses

  scope :valid_blogs, -> { where("title != '' AND body != ''") }
  scope :invalid_blogs, -> { where("title = '' OR body = ''") }
end
