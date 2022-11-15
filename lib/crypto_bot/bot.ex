defmodule CryptoBot.Bot do
  @moduledoc """
    Bot module is used for sending messages to messanger bot.
  """
  import Logger

  @base_message_url "https://graph.facebook.com/v15.0/me/messages"

  @doc """
   function for sending messages to facebook bot.
  """

  @spec send_message(map()) :: atom()
  def send_message(msg_template) do
    url = message_url()
    headers = [{"Content-type", "application/json"}]

    case HTTPoison.post(url, Jason.encode!(msg_template), headers, []) do
      {:ok, _response} ->
        Logger.info("Message Sent to Bot")
        :ok

      {:error, reason} ->
        Logger.error("Error in sending message to bot, #{inspect(reason)}")
        :error
    end
  end

  @doc false

  defp message_url do
    token = System.get_env("FACEBOOK_PAGE_ACCESS_TOKEN")
    token_path = "?access_token=#{token}"
    Path.join([@base_message_url, token_path])
  end
end
