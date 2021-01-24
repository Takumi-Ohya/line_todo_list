class AddBodyToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :body, :text
  end
end
