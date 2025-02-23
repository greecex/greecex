defmodule Greecex.Subscribers.SubscriberNotifier do
  import Swoosh.Email

  alias Greecex.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Greece |> Elixir", "greecex@amignosis.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm subscriber.
  """
  def deliver_confirmation_instructions(subscriber, url) do
    deliver({subscriber.email, subscriber.email}, "Thank you for joining Greece |> Elixir", """
    Hi #{subscriber.email},

    Thank you for joining Greece |> Elixir!

    Can you please confirm your email address by clicking on the link below?

    #{url}

    Cheers,
    The Greece |> Elixir Team
    """)
  end
end
