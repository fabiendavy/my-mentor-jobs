class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.integer :length
      t.date :date
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
