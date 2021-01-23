require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "タスクの一覧を取得できる" do
      get tasks_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /tasks/:id" do
    it "特定のタスクのレコードを取得できる" do

    end

  end

  describe "POST /tasks" do
    it "タスクのレコードを作成できる" do

    end

  end

  describe "PATCH(PUT) /users/:id" do
    it "タスクのレコードを更新できる" do

    end

  end

  describe "DELETE /users/:id" do
    it "タスクのレコードを削除できる" do

    end

  end
end
