class AdjustTipAttributes < ActiveRecord::Migration
  def up

    remove_column :tips, :is_anonymous
    rename_column :tips, :can_purchase_with_reputation, :is_free
    add_column    :tips, :display_as, :string
    add_column    :tips, :is_compliment, :boolean, default: false

  end

  def down

    add_column    :tips, :is_anonymous, :boolean
    rename_column :tips, :is_free, :can_purchase_with_reputation
    remove_column :tips, :display_as
    remove_column :tips, :is_compliment

  end
end
