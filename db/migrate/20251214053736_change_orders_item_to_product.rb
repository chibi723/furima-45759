class ChangeOrdersItemToProduct < ActiveRecord::Migration[7.1]
  def change
    remove_reference :orders, :item, foreign_key: true
    add_reference :orders, :product, null: false, foreign_key: true
  end
end
