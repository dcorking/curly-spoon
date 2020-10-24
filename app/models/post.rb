# frozen_string_literal: true

class Post < ApplicationRecord
  scope :expired, -> { where('expires < ?', DateTime.now) }

  def self.current
    where('expires >= ?', DateTime.now).where('valid_from <= ?', DateTime.now)
  end
end
