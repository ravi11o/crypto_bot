defmodule CryptoBotWeb.PageControllerTest do
  use CryptoBotWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  describe "verfiy webhook token with invalid or no params" do
    test "GET /api/webhook", %{conn: conn} do
      conn = get(conn, "/api/webhook")
      assert json_response(conn, 403)["status"] == "error"
    end
  end

  # valid webhook url returns hub.challenge as result

  @valid_webhook_url "/api/webhook?hub.mode=subscribe&hub.verify_token=cryptobot&hub.challenge=123456789"

  describe "verfiy webhook token with valid params" do
    test "GET #{@valid_webhook_url}", %{conn: conn} do
      conn = get(conn, @valid_webhook_url)
      assert json_response(conn, 200) == 123_456_789
    end
  end

  # Bot messages are handled using post request on /api/webhook which returns by sending message to bot

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

  describe "handle bot messages event using post webhook path" do
    test "POST webhook callback route", %{conn: conn} do
      conn = post(conn, "/api/webhook", @bot_message)
      assert json_response(conn, 200) == %{"status" => "ok"}
    end
  end

  # Bot postback are handled using post request on /api/webhook which returns by sending reply to bot
  @postback_message %{
    "entry" => [
      %{
        "id" => "104123649187014",
        "messaging" => [
          %{
            "postback" => %{
              "mid" =>
                "m_YEmse03QiquX52BhlTTb86w5ZvSjiJEv5AjJsGEEb6lzdEmyy4xxRKnBt_aLRhYTEeGoEIZLxeUGiNNNz2jbmg",
              "payload" => "id",
              "title" => "Coin ID"
            },
            "recipient" => %{"id" => "104123649187014"},
            "sender" => %{"id" => "5545433725582136"},
            "timestamp" => 1_668_579_952_202
          }
        ],
        "time" => 1_668_580_294_338
      }
    ],
    "object" => "page"
  }

  describe "handle postback bot messages event using post webhook path" do
    test "POST postback webhook callback route", %{conn: conn} do
      conn = post(conn, "/api/webhook", @postback_message)
      assert json_response(conn, 200) == %{"status" => "ok"}
    end
  end
end
