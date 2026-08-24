class DashboardController < ApplicationController
  def index
    @tasks = Task.order(created_at: :desc).limit(10)
    @new_task = Task.new
    @total_tasks = Task.count
    @completed_tasks = Task.where(status: "completed").count
    @avg_time = Task.where(status: "completed").average(:processing_time_seconds)&.round(1) || 0
  end
end
