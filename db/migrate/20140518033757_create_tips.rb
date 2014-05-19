class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|

      t.boolean :is_annonymous
      t.boolean :can_purchase_with_reputation

      t.boolean :sent
      t.timestamp :send_at

      t.timestamps
    end
  end
end
