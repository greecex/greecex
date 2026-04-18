defmodule GreecexWeb.PageController do
  use GreecexWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
