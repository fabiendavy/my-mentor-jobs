class Field < ApplicationRecord
  has_many :skills
  has_many :requests
  has_many :teachers, through: :skills
  has_many :levels, through: :skills
end
