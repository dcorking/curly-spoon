class Post < ApplicationRecord
  scope :expired, -> { where('expires < ?', DateTime.now)}
end
