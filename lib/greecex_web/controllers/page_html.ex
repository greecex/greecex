defmodule GreecexWeb.PageHTML do
  @moduledoc """
  Templates for the landing page.

  Every other page is a LiveView, so this is one of the few things left
  rendering through a controller.
  """
  use GreecexWeb, :html

  embed_templates "page_html/*"
end
