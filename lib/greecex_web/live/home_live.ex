defmodule GreecexWeb.HomeLive do
  use GreecexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Home")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center mt-12">
      <p class="text-2xl font-semibold text-zinc-800">
        Coming soon<span class="animate-blink text-purple-600">_</span>
      </p>
    </div>
    """
  end
end
