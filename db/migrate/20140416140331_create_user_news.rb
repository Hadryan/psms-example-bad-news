class CreateUserNews < ActiveRecord::Migration
  def change
    create_table :user_news do |t|
      t.integer :user_id
      t.references :news, index: true

      t.timestamps
    end
  end
end
