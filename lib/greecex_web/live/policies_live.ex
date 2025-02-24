defmodule GreecexWeb.PoliciesLive do
  use GreecexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Policies")}
  end

  def render(assigns) do
    ~H"""
    <div class="prose">
      <h1>Policies</h1>
      <ul>
        <li><.link navigate={~p"/privacy"}>Privacy</.link></li>
        <li><.link navigate={~p"/trademark"}>Trademark</.link></li>
        <li>
          <.link href="https://github.com/greecex/greecex/blob/main/CODE_OF_CONDUCT.md">
            Code of Conduct
          </.link>
        </li>
      </ul>
    </div>
    """
  end
end
