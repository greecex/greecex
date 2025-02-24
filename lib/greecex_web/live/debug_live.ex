defmodule GreecexWeb.DebugLive do
  use GreecexWeb, :live_view

  defp maybe_header_ip(address, header_ip) do
    if header_ip do
      header_ip |> List.first() |> String.split(",") |> List.first()
    else
      address
    end
  end

  defp maybe_peer_data_ip(address, peer_data_ip) do
    if peer_data_ip do
      peer_data_ip |> Tuple.to_list() |> Enum.join(".")
    else
      address
    end
  end

  def mount(_params, _session, socket) do
    peer_data = get_connect_info(socket, :peer_data)
    x_headers = get_connect_info(socket, :x_headers)
    header_ip = x_headers[:x_forwarded_for]
    peer_data_ip = peer_data[:address]

    address =
      ""
      |> maybe_header_ip(header_ip)
      |> maybe_peer_data_ip(peer_data_ip)

    {:ok,
     assign(socket,
       page_title: "Debug",
       peer_data: peer_data,
       address: address,
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
