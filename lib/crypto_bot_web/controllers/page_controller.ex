defmodule CryptoBotWeb.PageController do
  use CryptoBotWeb, :controller

  # alias CryptoBot.Bot

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

  defp verify_webhook(%{"hub.mode" => mode, "hub.verify_token" => token}) do
    webhook_verify_token = System.get_env("FACEBOOK_WEBHOOK_VERIFY_TOKEN")
    mode == "subscribe" && token == webhook_verify_token
  end
end