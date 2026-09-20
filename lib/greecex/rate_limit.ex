defmodule Greecex.RateLimit do
  @moduledoc """
  ETS-backed rate limiting, used to cap subscribe attempts per IP.

  In-memory by design. A restart clears the counters, which is acceptable
  for a signup form and avoids putting this in the database.
  """
  use Hammer, backend: :ets

  def start do
    # Cleanup every 10 minutes
    start_link(clean_period: :timer.minutes(10))
  end
end
