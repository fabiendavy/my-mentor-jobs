class Level < ApplicationRecord
  has_many :skills
  has_many :requests
  has_many :teachers, through: :skills
  has_many :fields, through: :skills
end
