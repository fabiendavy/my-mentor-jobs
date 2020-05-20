class Skill < ApplicationRecord
  belongs_to :field
  belongs_to :level
  belongs_to :teacher
end
