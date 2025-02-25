defmodule GreecexWeb.SubscribeLiveTest do
  use GreecexWeb.ConnCase
  alias Greecex.Subscribers
  import Phoenix.LiveViewTest

  describe "SubscribeLive" do
    def setup do
      :ets.delete_all_objects(Greecex.RateLimit)
    end

    test "renders form", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/subscribe")
      assert html =~ "Subscribe"
      assert html =~ "Email"
      assert html =~ "City"
      assert html =~ "Are you interested in co-organizing meetups in the nearest city?"
    end

    test "validates form data in real-time", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/subscribe")

      assert view
             |> form("#subscribe-form", %{
               "subscriber" => %{"email" => "invalid"}
             })
             |> render_change() =~ "must have the @ sign and no spaces"
    end

    test "creates subscriber with valid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/subscribe")

      subscriber = %{
        subscriber: %{
          email: "test@example.com",
          city: "Athens",
          elixir_experience: "Beginner",
          willing_to_coorganize: true
        }
      }

      view
      |> form("#subscribe-form", subscriber)
      |> render_submit()

      assert render(view) =~ "Thank you for subscribing!"
    end

    test "does not reveal that an email has already been used to subscribe", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/subscribe")

      existing_subscriber = %{
        "email" => "test@example.com",
        "city" => "Athens",
        "elixir_experience" => "I am experienced",
        "willing_to_coorganize" => true
      }

      Subscribers.create_subscriber(existing_subscriber)

      subscriber = %{
        subscriber: %{
          email: "test@example.com",
          city: "Athens",
          elixir_experience: "Beginner",
          willing_to_coorganize: true
        }
      }

      view
      |> form("#subscribe-form", subscriber)
      |> render_submit()

      assert render(view) =~ "Thank you for subscribing!"
    end
  end

  describe "honeypot" do
    test "rejects submission when honeypot field is filled", %{conn: conn} do
      # Mount the LiveView
      {:ok, view, _html} = live(conn, ~p"/subscribe")

      # Simulate a bot filling the honeypot field
      bot_params = %{
        "subscriber" => %{
          "email" => "bot@example.com",
          "city" => "Athens",
          "willing_to_coorganize" => "false",
          "elixir_experience" => "I am a bot"
        },
        # Honeypot triggered
        "website" => "bot-filled-value"
      }

      # Submit the form
      result = render_submit(view, "subscribe", bot_params)

      # Assert the honeypot error is shown
      assert result =~ "It seems like you&#39;re a bot. If not, please try again."
      # Form is still visible
      assert result =~ "subscribe-form"
      # Success message not shown
      refute result =~ "Thank you for subscribing"
    end
  end

  describe "Rate limit" do
    test "rejects submission when rate limit is exceeded", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/subscribe")

      params = %{
        "subscriber" => %{
          "email" => "user@example.com",
          "city" => "Thessaloniki",
          "willing_to_coorganize" => "true",
          "elixir_experience" => "Elixir newbie"
        },
        "website" => ""
      }

      for _ <- 1..8 do
        render_submit(view, "subscribe", params)
      end

      result = render_submit(view, "subscribe", params)

      assert result =~ "Too many requests. Try again in a bit."
      assert result =~ "subscribe-form"
      refute result =~ "Thank you for subscribing"

      on_exit(fn ->
        # Clean up the rate limit key after the test
        :ets.delete_all_objects(Greecex.RateLimit)
      end)
    end
  end
end
