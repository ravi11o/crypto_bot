defmodule CryptoBot.Template do
  @moduledoc """
  This module has different templates for replying messages to the bot.
  """

  @base_url "https://graph.facebook.com/v15.0"

  @doc """
  This is the text message format for replying to messanger bot.
  """

  @spec text_message(map(), String.t()) :: map()
  def text_message(event, text) do
    %{
      "recipient" => recipient(event),
      "message" => %{"text" => text}
    }
  end

  @doc """
  This is the template format for displaying buttons in the messanger bot.
  """

  @spec buttons(map(), String.t(), list()) :: map()
  def buttons(event, template_title, buttons) do
    buttons = Enum.map(buttons, &prepare_button/1)

    payload = %{
      "template_type" => "button",
      "text" => template_title,
      "buttons" => buttons
    }

    template_message(event, payload)
  end

  @spec buttons(map(), String.t(), list()) :: map()
  def generic_buttons(event, title, buttons) do
    first_three = Enum.take(buttons, 3)
    remaining = buttons -- first_three

    payload = %{
      "template_type" => "generic",
      "elements" => [
        %{
          "title" => title,
          "buttons" => Enum.map(first_three, &prepare_button/1)
        },
        %{
          "title" => title,
          "buttons" => Enum.map(remaining, &prepare_button/1)
        }
      ]
    }

    template_message(event, payload)
  end

  @doc """
  This is the button type for template messages
  """

  @spec prepare_button(tuple()) :: map()
  def prepare_button({message_type, title, payload}) do
    %{
      "type" => "#{message_type}",
      "title" => title,
      "payload" => payload
    }
  end

  defp template_message(event, payload) do
    message = %{
      "attachment" => %{
        "type" => "template",
        "payload" => payload
      }
    }

    %{
      "message" => message,
      "recipient" => recipient(event)
    }
  end

  @doc """
  Extract message data from event returned from messanger bot.
  """

  @spec get_event_data(map()) :: map()
  def get_event_data(event) do
    [entry | _any] = event["entry"]
    [messaging | _any] = entry["messaging"]
    messaging
  end

  defp recipient(event) do
    sender = get_event_data(event)["sender"]

    %{
      "id" => sender["id"]
    }
  end

  @doc """
  Get first name of sender from profile data requested by making API request to facebook.
  """

  @spec get_first_name(map()) :: String.t()
  def get_first_name(event) do
    sender = get_event_data(event)["sender"]
    # chat_bot = Application.get_env(:crypto_bot, :facebook_chat_bot)
    # page_token = chat_bot.page_access_token
    page_token = System.get_env("FACEBOOK_PAGE_ACCESS_TOKEN")
    token_path = "?access_token=#{page_token}"
    profile_path = Path.join([@base_url, sender["id"], token_path])

    case HTTPoison.get(profile_path) do
      {:ok, response} ->
        Jason.decode!(response.body)

      {:error, error} ->
        IO.inspect(error)
    end
    |> Map.fetch!("first_name")
  end

  @doc """
  Greeting message for Bot
  """

  @spec greet() :: String.t()
  def greet() do
    """
    Hi there! :)
    Welcome to CryptoBot

    Invalid input provided.
    Say hi to begin
    """
  end
end
