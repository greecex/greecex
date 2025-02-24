defmodule GreecexWeb.SubscribeLiveTest do
  use GreecexWeb.ConnCase
  alias Greecex.Subscribers
  import Phoenix.LiveViewTest

  describe "SubscribeLive" do
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
end
