defmodule Mix.Tasks.Greecex.Context do
  use Mix.Task

  @shortdoc "Helps prepare a context checklist when uploading a zip for Greecex support"

  @moduledoc """
  Interactive helper to generate a context checklist when uploading a Greecex project zip.

  Usage:
      mix greecex.context
  """

  def run(_) do
    focus_area = prompt("Focus Area (what are you working on?)")
    direction = prompt("Direction (advice only / full implementation / atomic commits)")
    special_constraints = prompt("Special Constraints (optional)")

    latest_zip = find_latest_zip() || "[your-uploaded-file.zip]"

    Mix.shell().info("""

    ---
    Uploaded: #{latest_zip}

    Focus Area: #{focus_area}

    Direction: #{direction}

    Special Constraints: #{special_constraints}
    ---
    """)
  end

  defp prompt(question) do
    IO.gets("#{question}\n> ")
    |> String.trim()
  end

  defp find_latest_zip do
    Path.wildcard("greecex-*.zip")
    |> Enum.sort()
    |> List.last()
  end
end
