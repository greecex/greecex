defmodule GreecexWeb.SubscribeLiveTest do
  use GreecexWeb.ConnCase
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
  end
end
