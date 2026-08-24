class Task < ApplicationRecord
  validates :title, presence: true

  # Transmitir em tempo real (Turbo Streams via ActionCable)
  after_create_commit -> { broadcast_prepend_to "tasks", target: "tasks_table_body", partial: "tasks/task", locals: { task: self } }
  after_update_commit -> { broadcast_replace_to "tasks", target: self, partial: "tasks/task", locals: { task: self } }
end
