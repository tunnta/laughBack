class RenameTitleIdColumnToAnswers < ActiveRecord::Migration[6.1]
  def change
    rename_column :answers, :title_id, :content_id
  end
end
