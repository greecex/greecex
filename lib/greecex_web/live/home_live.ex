defmodule GreecexWeb.HomeLive do
  use GreecexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Home")}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto text-center px-6">
      <h1 class="text-3xl font-extrabold text-gray-900 tracking-tight">
        Join the community!
      </h1>

      <p class="mt-4 text-base text-gray-700 leading-relaxed text-justify">
        <strong>Elixir</strong>
        powers <strong>scalable, fault-tolerant applications</strong>, while
        <strong>Phoenix and LiveView</strong>
        streamline development by reducing context switching.
      </p>

      <div class="mt-8 text-left space-y-4">
        <h2 class="text-base font-semibold text-gray-900">
          Why join?
        </h2>
      </div>

      <div class="mx-auto mt-4 max-w-7xl px-6 sm:mt-4 md:mt-4 lg:px-8 text-left">
        <dl class="mx-auto grid max-w-2xl grid-cols-1 gap-x-6 gap-y-6 text-sm text-gray-600 sm:grid-cols-2 lg:mx-0 lg:max-w-none lg:grid-cols-3 lg:gap-x-8 lg:gap-y-8">
          <div class="relative pl-9">
            <dt class="inline font-semibold text-gray-900">
              <.icon
                name="hero-information-circle-solid"
                class="absolute left-1 top-1 size-6 text-purple-600"
              /> Stay informed
            </dt>
            <dd class="inline">
              about local Elixir meetups and other events near you.
            </dd>
          </div>
          <div class="relative pl-9">
            <dt class="inline font-semibold text-gray-900">
              <.icon
                name="hero-chat-bubble-bottom-center-text-solid"
                class="absolute left-1 top-1 size-6 text-purple-600"
              /> Gain access
            </dt>
            <dd class="inline">
              to community discussions and learning resources.
            </dd>
          </div>
          <div class="relative pl-9">
            <dt class="inline font-semibold text-gray-900">
              <.icon name="hero-newspaper-solid" class="absolute left-1 top-1 size-6 text-purple-600" />
              Receive our upcoming
            </dt>
            <dd class="inline">
              Elixir-focused newsletter.
            </dd>
          </div>
          <div class="relative pl-9">
            <dt class="inline font-semibold text-gray-900">
              <.icon name="hero-briefcase-solid" class="absolute left-1 top-1 size-6 text-purple-600" />
              Discover job opportunities
            </dt>
            <dd class="inline">
              in Greece and beyond.
            </dd>
          </div>
          <div class="relative pl-9">
            <dt class="inline font-semibold text-gray-900">
              <.icon
                name="hero-eye-dropper-solid"
                class="absolute left-1 top-1 size-6 text-purple-600"
              /> Help shape
            </dt>
            <dd class="inline">
              the future of Elixir adoption in Greece.
            </dd>
          </div>
          <div class="relative pl-9">
            <dt class="inline font-semibold text-gray-900">
              <.icon
                name="hero-user-group-solid"
                class="absolute left-1 top-1 size-6 text-purple-600"
              /> Join us
            </dt>
            <dd class="inline">
              whether you're experienced in Elixir or just curious to learn.
            </dd>
          </div>
        </dl>
      </div>

      <div class="mt-10">
        <!-- Placeholder for the subscription form -->
      </div>
    </div>
    """
  end
end
