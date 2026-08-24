require 'rails_helper'

RSpec.describe ProcessTaskJob, type: :job do
  describe '#perform' do
    let(:task) { Task.create!(title: "Processar Relatorio") }

    it 'processes the task and updates status to completed' do
      # Executa o job de forma síncrona
      ProcessTaskJob.new.perform(task.id)

      task.reload
      expect(task.status).to eq('completed')
      expect(task.result_summary).to include('Análise concluída com sucesso')
      expect(task.processing_time_seconds).to be_present
    end
  end
end
