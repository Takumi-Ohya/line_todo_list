require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    subject {get(tasks_path)}
    #タスクを事前に3つ作成
    before {3.times{create(:task)}}
    it "タスクの一覧を取得できる" do
      subject
      res = JSON.parse(response.body)

      #タスクが3つ生成されていることを確認
      expect(res.length).to eq 3
      #タスクに必要な情報が入っているかを確認
      expect(res[0].keys).to eq ["id", "created_at", "updated_at", "body"]
      #ステータスコード200が返ってくることを確認
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /tasks/:id" do
    subject {get(task_path(task_id))}
    context "指定したidのタスクが存在するとき" do
      let(:task_id){task.id}
      let(:task){create(:task)}

      it "そののタスクのレコードを取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res["body"]).to eq task.body
        expect(res["id"]).to eq task.id
        expect(response).to have_http_status(200)

      end
    end
    context "指定したidのタスクが存在しないとき" do
      let(:task_id){1000000}
      it "タスクが見付からない" do
        expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  describe "POST /tasks" do
    subject{post(tasks_path , params:params)}
    context "適切なパラメータを送信したとき" do
      let(:params) {{task: attributes_for(:task)}}
      it "タスクのレコードを作成できる" do
        expect{subject}.to change {Task.count}.by(1)
        binding.pry
        res = JSON.parse(response.body)
        expect(res["body"]).to eq params[:task][:body]
        expect(response).to have_http_status(200)

      end
    end

    context "不適切なパラメータを送信したとき" do
      let(:params) {attributes_for(:task)}
      it "エラーする" do
        expect{subject}.to raise_error(ActionController::ParameterMissing)
      end
    end

  end



  describe "DELETE /users/:id" do
    subject{delete(task_path(task_id))}
    let(:task_id){task.id}
    let!(:task){create(:task)}
    fit "タスクのレコードを削除できる" do
      expect{subject}.to change{Task.count}.by(-1)
    end

  end
end
