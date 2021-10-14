class AddUserSubToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :user_sub, :string
  end
end
