class FixAttributeSpellingOnTips < ActiveRecord::Migration
  def change
    rename_column :tips, :is_annonymous, :is_anonymous
  end
end
