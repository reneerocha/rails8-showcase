require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is valid with a title' do
      task = Task.new(title: 'Fazer café')
      expect(task).to be_valid
    end

    it 'is invalid without a title' do
      task = Task.new(title: nil)
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end
  end

  describe 'defaults' do
    it 'defaults status to pending' do
      task = Task.create!(title: 'Tarefa pendente')
      expect(task.status).to eq('pending')
    end
  end
end
