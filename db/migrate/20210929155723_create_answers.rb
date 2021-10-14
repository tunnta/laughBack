class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.integer :title_id
      t.string :answer

      t.timestamps
    end
  end
end
