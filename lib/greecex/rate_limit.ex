defmodule Greecex.RateLimit do
  use Hammer, backend: :ets

  def start do
    # Cleanup every 10 minutes
    start_link(clean_period: :timer.minutes(10))
  end
end
