class AddPricePerHourToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :price_per_hour, :integer
  end
end
