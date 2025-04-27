defmodule Mix.Tasks.Greecex.Zip do
  use Mix.Task

  @shortdoc "Packs the Greecex repository into a clean greecex-YYYYMMDD-HHMM.zip for sharing"

  @moduledoc """
  This task zips the Greecex repo into `greecex-YYYYMMDD-HHMM.zip`, excluding unnecessary files and folders.

  Usage:
      mix greecex.zip
  """

  @excludes [
    "_build",
    "deps",
    ".git",
    ".DS_Store"
  ]

  def run(_) do
    app_root = File.cwd!()
    zip_name = "greecex-#{timestamp()}.zip"
    zip_file = Path.join(app_root, zip_name)

    entries =
      Path.wildcard("**", match_dot: true)
      |> Enum.reject(&excluded?/1)

    case :zip.create(
           String.to_charlist(zip_file),
           Enum.map(entries, &String.to_charlist/1),
           [:cooked, {:compress, :all}]
         ) do
      {:ok, _zip_file_path} ->
        {:ok, info} = File.stat(zip_file)
        size_mb = Float.round(info.size / 1_048_576, 2)

        Mix.shell().info("Created #{zip_file} (#{size_mb} MB) with #{length(entries)} files.")

      {:error, reason} ->
        Mix.raise("Failed to create zip: #{inspect(reason)}")
    end
  end

  defp excluded?(path) do
    Enum.any?(@excludes, fn excl ->
      String.starts_with?(path, excl) or String.ends_with?(path, excl)
    end)
  end

  defp timestamp do
    {{year, month, day}, {hour, minute, _second}} = :calendar.local_time()
    "#{pad(year)}#{pad(month)}#{pad(day)}-#{pad(hour)}#{pad(minute)}"
  end

  defp pad(n) when is_integer(n) and n < 10, do: "0#{n}"
  defp pad(n), do: "#{n}"
end
