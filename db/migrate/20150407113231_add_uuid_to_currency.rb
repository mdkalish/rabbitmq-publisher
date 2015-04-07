class AddUuidToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :uuid, :string
  end
end
