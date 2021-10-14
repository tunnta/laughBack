class CreateGoodUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :good_users do |t|
      t.integer :answer_id
      t.string :sub

      t.timestamps
    end
  end
end
