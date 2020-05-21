class Course < ApplicationRecord
  belongs_to :request

  validates :date, presence: true
  validates :length, numericality: { :greater_than_or_equal_to => 0 }
end
