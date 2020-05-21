class Request < ApplicationRecord
  belongs_to :field
  belongs_to :level
  belongs_to :teacher, optional: true
  has_many :courses, dependent: :destroy

  validates :client_name, presence: true
  validates :price_per_hour, numericality: { :greater_than_or_equal_to => 0 }
end
