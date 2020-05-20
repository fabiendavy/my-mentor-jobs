class CreateLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.string :grade
      t.string :cycle

      t.timestamps
    end
  end
end
