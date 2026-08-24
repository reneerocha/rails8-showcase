require 'rails_helper'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe "Tasks", type: :request do
  describe "POST /tasks" do
    context "with valid parameters" do
      let(:valid_params) { { task: { title: "Minha tarefa assincrona" } } }

      it "creates a new Task" do
        expect {
          post tasks_path, params: valid_params
        }.to change(Task, :count).by(1)
      end

      it "enqueues the ProcessTaskJob" do
        expect {
          post tasks_path, params: valid_params
        }.to change(ProcessTaskJob.jobs, :size).by(1)
      end

      it "redirects or returns turbo stream success" do
        post tasks_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { task: { title: "" } } }

      it "does not create a new Task" do
        expect {
          post tasks_path, params: invalid_params
        }.not_to change(Task, :count)
      end
    end
  end
end
