defmodule GreecexWeb.DebugLive do
  use GreecexWeb, :live_view

  alias RemoteIp

  def mount(_params, _session, socket) do
    peer_data = get_connect_info(socket, :peer_data)
    x_headers = get_connect_info(socket, :x_headers)

    address =
      RemoteIp.from(x_headers, proxies: ["66.241.124.124"])

    address_as_string =
      cond do
        address != nil ->
          address
          |> Tuple.to_list()
          |> Enum.join(".")

        true ->
          peer_data.address |> Tuple.to_list() |> Enum.join(".")
      end

    # address =
    #   RemoteIp.from([{"x-forwarded-for", "45.66.42.184, 66.241.124.124"}],
    #     proxies: ["66.241.124.124"]
    #   )
    #   |> Tuple.to_list()
    #   |> Enum.join(".")

    {:ok,
     assign(socket,
       page_title: "Debug",
       peer_data: peer_data,
       address: address_as_string,
       x_headers: x_headers
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="prose">
      <h1>Debug</h1>
      <h3>Peer data:</h3>
      <ul>
        <%= for {key, value} <- @peer_data do %>
          <li>{key}: {inspect(value)}</li>
        <% end %>
      </ul>
      <h3>X Headers:</h3>
      <ul>
        <%= for {key, value} <- @x_headers do %>
          <li>{key}: {inspect(value)}</li>
        <% end %>
      </ul>
      <h3>Address:</h3>
      <ul>
        <li>{inspect(@address)}</li>
      </ul>
    </div>
    """
  end
end
