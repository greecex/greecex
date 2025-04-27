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

    output = """

    ---
    Uploaded: #{latest_zip}

    Focus Area: #{focus_area}

    Direction: #{direction}

    Special Constraints: #{special_constraints}
    ---
    """

    Mix.shell().info(output)

    maybe_copy_to_clipboard(output)
  end

  defp maybe_copy_to_clipboard(output) do
    if Code.ensure_loaded?(Clipboard) and function_exported?(Clipboard, :copy, 1) do
      _ = apply(Clipboard, :copy, [output])
      Mix.shell().info("\n✅ Copied to clipboard!")
    else
      Mix.shell().info("\n⚠️ Clipboard not available, skipping copy.")
    end
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
