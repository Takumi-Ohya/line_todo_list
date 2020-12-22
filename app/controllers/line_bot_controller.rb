class LineBotController < ApplicationController
  require "line/bot"

  protect_from_forgery with: :null_session

  def callback
    # LINEで送られてきたメッセージのデータを取得
    body = request.body.read

    # LINE以外からリクエストが来た場合 Error を返す
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      head :bad_request and return
    end

    # LINEで送られてきたメッセージを適切な形式に変形
    events = client.parse_events_from(body)

    events.each do |event|
      # LINE からテキストが送信された場合
      if (event.type === Line::Bot::Event::MessageType::Text)
        message = event["message"]["text"]

        #メッセージの内容による条件分岐(createかdestroyかshowか)
        if (message == "いちらん")
          text1 =
            Task.all.map do |task|
              "#{task.id}.#{task.body}"
            end
          text2 = text1.join("\n")


        else
          # 送信されたメッセージをDBに保存する
          Task.create(body: message)
          #binding.pry
          text2 = "タスク：「#{message}」を登録しました"
        end
        reply_message = {
           type: "text",
          text: text2 #LINEに返すメッセージ
        }
        client.reply_message(event["replyToken"], reply_message)
      end
    end

    # LINE の webhook API との連携をするために status code 200 を返す
    render json: { status: :ok }
  end

  private

    def client
      @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      end
    end
end
