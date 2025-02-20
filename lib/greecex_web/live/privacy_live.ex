defmodule GreecexWeb.PrivacyLive do
  @static_file "privacy.md"

  use GreecexWeb, :live_view
  alias Earmark

  require Logger

  def mount(_params, _session, socket) do
    html = load_content()
    {:ok, assign(socket, page_title: "Privacy policy", html: html)}
  end

  defp load_content do
    file_path = Application.app_dir(:greecex, "priv/static/#{@static_file}")

    case File.read(file_path) do
      {:ok, content} ->
        Earmark.as_html!(content)

      {:error, reason} ->
        Logger.error("Failed to load #{@static_file} from #{file_path}: #{inspect(reason)}")
        "<p>Failed to load content.</p>"
    end
  end

  def render(assigns) do
    ~H"""
    <div class="prose">
      {raw(@html)}
    </div>
    """
  end
end
