defmodule CryptoBotWeb.PageController do
  use CryptoBotWeb, :controller

  alias CryptoBot.{Bot, MessageHandler, Template}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def verify_webhook_token(conn, params) do
    verified? = verify_webhook(params)

    if verified? do
      conn
      |> put_resp_content_type("application/json")
      |> resp(200, params["hub.challenge"])
      |> send_resp()
    else
      conn
      |> put_resp_content_type("application/json")
      |> put_status(:forbidden)
      |> json(%{status: "error", message: "unauthorized"})
    end
  end

  def handle_event(conn, event_data) do
    # IO.inspect(event_data)

    case Template.get_event_data(event_data) do
      %{"message" => message} ->
        MessageHandler.handle_message(message, event_data)

      %{"postback" => postback} ->
        MessageHandler.handle_postback(postback, event_data)

      _ ->
        error_template = Template.text_message(event_data, "Something went wrong.")

        Bot.send_message(error_template)
    end

    conn
    |> put_status(:ok)
    |> json(%{status: "ok"})
  end

  defp verify_webhook(%{"hub.mode" => mode, "hub.verify_token" => token}) do
    chat_bot = Application.get_env(:crypto_bot, :facebook_chat_bot)
    webhook_verify_token = chat_bot.webhook_verify_token
    # webhook_verify_token = System.get_env("FACEBOOK_WEBHOOK_VERIFY_TOKEN")
    mode == "subscribe" && token == webhook_verify_token
  end
end
