defmodule CryptoBot.TemplateTest do
  use ExUnit.Case
  alias CryptoBot.Template

  @bot_message %{
    "entry" => [
      %{
        "id" => "104123649187014",
        "messaging" => [
          %{
            "message" => %{
              "mid" =>
                "m_VTNYFoR0PiA7izqQ4g_F7qw5ZvSjiJEv5AjJsGEEb6mTH7FpooAxqjqkNNWhualhtxQwfAyQOt73ExH4Af9qBA",
              "text" => "hi"
            },
            "recipient" => %{"id" => "104123649187014"},
            "sender" => %{"id" => "5545433725582136"},
            "timestamp" => 1_668_578_818_466
          }
        ],
        "time" => 1_668_578_818_847
      }
    ],
    "object" => "page"
  }

  def message_format_fixture do
    Template.text_message(@bot_message, "hi there")
  end

  def template_format_fixture do
    Template.template_message(@bot_message, nil)
  end

  def recipient_fixture do
    Template.recipient(@bot_message)
  end

  def event_data_fixture do
    Template.get_event_data(@bot_message)
  end

  def first_name_fixture do
    Template.get_first_name(@bot_message)
  end

  def greet_fixture do
    Template.greet()
  end

  describe "Message format for sending text message to bot" do
    test "text message response format" do
      message_format = message_format_fixture()

      assert Map.has_key?(message_format, "message") == true
      assert Map.has_key?(message_format, "recipient") == true
      assert message_format["message"]["text"] == "hi there"
    end
  end

  describe "Message format for sending template message to bot" do
    test "template message response format" do
      template_format = template_format_fixture()

      assert Map.has_key?(template_format, "message") == true
      assert Map.has_key?(template_format, "recipient") == true
      assert template_format["message"]["attachment"]["type"] == "template"
    end
  end

  describe "Get recipient data from bot message" do
    test "create recipient map" do
      recipient = recipient_fixture()

      assert Map.has_key?(recipient, "id") == true
      assert recipient["id"] == "5545433725582136"
    end
  end

  describe "Get event data from callback webhook url like messages, recipient, sender etc" do
    test "event data from bot messages" do
      event_data = event_data_fixture()

      assert Map.has_key?(event_data, "message") == true
      assert Map.has_key?(event_data, "recipient") == true
      assert Map.has_key?(event_data, "sender") == true
    end
  end

  describe "Get first name by making API request to facebook BOT" do
    test "Get first name" do
      assert first_name_fixture() == "Suraj"
    end
  end

  describe "Greet unknown user" do
    test "Welcome when invalid input is provided" do
      assert String.contains?(greet_fixture(), "Welcome to CryptoBot") == true
    end
  end
end
