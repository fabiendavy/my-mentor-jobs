class Teacher < ApplicationRecord
  has_many :skills, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :fields, through: :skills
  has_many :levels, through: :skills

  accepts_nested_attributes_for :fields
  accepts_nested_attributes_for :levels

  validates :first_name, presence: true
  validates :last_name, presence: true
end
