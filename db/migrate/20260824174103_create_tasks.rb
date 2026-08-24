class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :status, null: false, default: "pending"
      t.text :result_summary
      t.integer :processing_time_seconds

      t.timestamps
    end

    add_index :tasks, :status
  end
end
