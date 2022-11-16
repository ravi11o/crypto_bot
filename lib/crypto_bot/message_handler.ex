defmodule CryptoBot.MessageHandler do
  @moduledoc """
  This module handles text as well as postback messages and other supporting functions
  """
  alias CryptoBot.{Template, Bot, Gecko}

  @doc """
  This handles text messages sent by the bot in order to respond.
  """

  @spec handle_message(map(), map()) :: any()
  def handle_message(%{"text" => text}, event)
      when text in ["hi", "hello", "Hi", "Hello", "hey", "Hey"] do
    first_name = Template.get_first_name(event)
    message = "Hello #{first_name}! :)"
    resp_template = Template.text_message(event, message)
    Bot.send_message(resp_template)
    provide_coin_options(event)
  end

  def handle_message(%{"text" => text}, event) do
    provide_coin_list(event, text)
  end

  @doc """
  This handles postback messages sent by messanger bot when an event is triggered like a button click.
  """

  @spec handle_postback(map(), map()) :: any()
  def handle_postback(%{"payload" => option}, event) when option in ["name", "id"] do
    event
    |> Template.text_message("You have selected coin #{option} to proceed.")
    |> Bot.send_message()

    request_coin(event, option)
  end

  def handle_postback(%{"payload" => "coin_" <> coin_id}, event) do
    message = show_price_list(coin_id)

    event
    |> Template.text_message(message)
    |> Bot.send_message()
  end

  @doc false

  defp provide_coin_options(event) do
    buttons = [
      {:postback, "Coin Name", "name"},
      {:postback, "Coin ID", "id"}
    ]

    template_title = "How would you like to search the crypto coin?"
    coin_type_template = Template.buttons(event, template_title, buttons)
    Bot.send_message(coin_type_template)
  end

  defp provide_coin_list(event, text) do
    message = Template.greet()

    coins = Gecko.search_coin(text)

    case coins do
      [] ->
        event
        |> Template.text_message(message)
        |> Bot.send_message()

      _ ->
        buttons = Enum.map(coins, &{:postback, "#{&1["name"]}", "coin_#{&1["id"]}"})

        template_title = "select one from options below."

        coin_list_template =
          if length(buttons) > 3 do
            Template.generic_buttons(event, template_title, buttons)
          else
            Template.buttons(event, template_title, buttons)
          end

        Bot.send_message(coin_list_template)
    end
  end

  defp request_coin(event, option) do
    event
    |> Template.text_message("Please input coin #{option} below.")
    |> Bot.send_message()
  end

  def show_price_list(coin_id) do
    price_feed = Gecko.fetch_usd_price(coin_id)

    message =
      Enum.reduce(price_feed, "", fn [time, price], acc ->
        acc <> "#{unix_to_date(time)}:- $#{Float.round(price, 2)} \n"
      end)

    "Price feed of last #{length(price_feed)} days for #{coin_id} \n\n" <> message
  end

  defp unix_to_date(timestamp) do
    timestamp
    |> DateTime.from_unix!(:millisecond)
    |> DateTime.to_date()
    |> Date.to_string()
  end
end
