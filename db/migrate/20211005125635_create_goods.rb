class CreateGoods < ActiveRecord::Migration[6.1]
  def change
    create_table :goods do |t|
      t.integer :answer_id
      t.integer :good

      t.timestamps
    end
  end
end
