# frozen_string_literal: true

class Post < ApplicationRecord
  scope :expired, -> { where('expires < ?', DateTime.now) }

  def self.current
    where('valid_from <= ? AND expires >= ?', DateTime.now, DateTime.now)
  end
end
