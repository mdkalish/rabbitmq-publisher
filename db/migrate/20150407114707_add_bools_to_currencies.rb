class AddBoolsToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :consumer_1, :boolean
    add_column :currencies, :consumer_2, :boolean
    add_column :currencies, :consumer_3, :boolean
  end
end
