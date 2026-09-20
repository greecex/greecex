defmodule GreecexWeb.PageControllerTest do
  use GreecexWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Greece |> Elixir"
  end
end
