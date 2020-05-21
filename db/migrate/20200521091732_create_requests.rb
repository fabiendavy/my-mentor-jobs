class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :client_name
      t.references :field, null: false, foreign_key: true
      t.references :level, null: false, foreign_key: true
      t.references :teacher, foreign_key: true

      t.timestamps
    end
  end
end
