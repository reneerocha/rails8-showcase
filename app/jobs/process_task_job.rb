class ProcessTaskJob
  include Sidekiq::Job

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task

    # 1. Atualizar para processando
    task.update!(status: "processing")

    # 2. Simular trabalho pesado
    sleep 3

    # 3. Gerar resultado
    processing_time = rand(2..5)
    summary = "Análise concluída com sucesso. Processados #{rand(100..500)} registros da fila. Índices do PostgreSQL aplicados para otimização de busca."

    # 4. Salvar com sucesso
    task.update!(
      status: "completed",
      result_summary: summary,
      processing_time_seconds: processing_time
    )
  rescue StandardError => e
    task&.update!(
      status: "failed",
      result_summary: "Erro no processamento: #{e.message}"
    )
  end
end
