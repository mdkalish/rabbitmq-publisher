class AddRatesToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :rates, :json
  end
end
