import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crypto_bot, CryptoBotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DYlHLpM9aYuU9KBnij7TQQVQiiH1ZRFop50x3gWErc1sxdXNjU1wMwqsaYpFhi47",
  server: false

# In test we don't send emails.
config :crypto_bot, CryptoBot.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
