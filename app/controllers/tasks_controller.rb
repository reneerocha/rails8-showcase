class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)

    if @task.save
      # Disparar o Job assíncrono do Sidekiq
      ProcessTaskJob.perform_async(@task.id)

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Tarefa enviada para fila!" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Título não pode ficar em branco." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task_form_container", partial: "tasks/form", locals: { task: @task }) }
      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:title)
  end
end
