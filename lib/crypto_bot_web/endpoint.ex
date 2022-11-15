defmodule CryptoBotWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :crypto_bot

  # def init(_key, config) do
  #   if config[:load_from_system_env] do
  #     port = System.fetch_env!("PORT")
  #     secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
  #     app_host = System.fetch_env!("APP_HOST")

  #     config =
  #       config
  #       |> Keyword.put(:http, [:inet6, port: port])
  #       |> Keyword.put(:secret_key_base, secret_key_base)
  #       |> Keyword.put(:url, host: app_host, scheme: "https", port: 443)

  #     {:ok, config}
  #   else
  #     {:ok, config}
  #   end
  # end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_crypto_bot_key",
    signing_salt: "/iyn0nvV"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :crypto_bot,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CryptoBotWeb.Router
end
