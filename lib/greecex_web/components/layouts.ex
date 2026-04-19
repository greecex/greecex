defmodule GreecexWeb.Layouts do
  @moduledoc """
  Layout components for the application.

  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is a function component
  called explicitly in templates.
  """
  use GreecexWeb, :html

  embed_templates "layouts/*"

  attr :flash, :map, required: true
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl">
      <.flash_group flash={@flash} />
      {render_slot(@inner_block)}
    </div>
    """
  end
end
