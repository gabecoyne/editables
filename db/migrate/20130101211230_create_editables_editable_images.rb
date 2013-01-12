class CreateEditablesEditableImages < ActiveRecord::Migration
  def change
    create_table :editable_images do |t|
      t.string :name

      t.timestamps
    end
    add_index :editable_images, [:name]
  end
end
