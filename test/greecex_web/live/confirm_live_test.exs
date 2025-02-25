defmodule GreecexWeb.ConfirmLiveTest do
  use GreecexWeb.ConnCase
  alias Greecex.Subscribers
  import Phoenix.LiveViewTest

  def setup do
    :ets.delete_all_objects(Greecex.RateLimit)
  end

  describe "ConfirmLive" do
    test "confirms a subscriber with a valid token", %{conn: conn} do
      {:ok, subscriber} =
        Subscribers.create_subscriber(%{"email" => "test@example.com", "city" => "Agrinio"})

      assert subscriber.confirmed_at == nil
      {:ok, view, _html} = live(conn, ~p"/confirm/#{subscriber.confirmation_token}")
      assert render(view) =~ "Thank you for confirming"
      subscriber = Subscribers.get_subscriber_by_email("test@example.com")
      assert subscriber.confirmed_at != nil
    end

    test "does not confirm a subscriber with an invalid token", %{conn: conn} do
      {:ok, subscriber} =
        Subscribers.create_subscriber(%{"email" => "test@example.com", "city" => "Agrinio"})

      assert subscriber.confirmed_at == nil
      {:ok, view, _html} = live(conn, ~p"/confirm/invalid_token")
      assert render(view) =~ "confirmation link"
      assert render(view) =~ "is invalid"
      subscriber = Subscribers.get_subscriber_by_email("test@example.com")
      assert subscriber.confirmed_at == nil
    end
  end
end
