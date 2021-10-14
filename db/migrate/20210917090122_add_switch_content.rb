class AddSwitchContent < ActiveRecord::Migration[6.1]
  def change
    add_column :contents, :switch, :integer
  end
end
