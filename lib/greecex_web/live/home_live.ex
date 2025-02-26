defmodule GreecexWeb.HomeLive do
  use GreecexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Home")}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto text-center">
      <h1 class="text-3xl font-extrabold text-gray-900 tracking-tight">
        Elixir is amazing!
      </h1>

      <p class="mt-4 text-base text-gray-700 leading-relaxed text-justify">
        <strong>Elixir</strong>
        powers <strong>scalable, fault-tolerant applications</strong>, while
        <strong>Phoenix and LiveView</strong>
        streamline development by reducing context switching.
      </p>

      <div class="mt-4 mb-12 text-center space-y-4">
        <.link
          navigate={~p"/subscribe"}
          class="rounded-md bg-purple-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-purple-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-purple-600"
        >
          Get community updates
        </.link>
      </div>

      <div class="mt-8 space-y-4">
        <h2 class="text-lg font-semibold text-gray-900">
          Why subscribe to updates?
        </h2>
      </div>

      <div class="mx-auto mt-4 max-w-7xl sm:mt-4 md:mt-4 text-left">
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

      <div class="bg-purple-50 mt-12 mb-2 rounded-md">
        <div class="mx-auto max-w-7xl px-6 py-12 sm:py-16 lg:flex lg:items-center lg:justify-between lg:px-8">
          <h2 class="max-w-2xl text-2xl font-semibold tracking-tight text-gray-900 sm:text-xl">
            Feeling major FOMO right? <br />Let's build the community together.
          </h2>
          <div class="mt-10 flex items-center justify-center gap-x-6 lg:mt-0 lg:shrink-0">
            <.link
              navigate={~p"/subscribe"}
              class="rounded-md bg-purple-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-purple-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-purple-600"
            >
              Do it!
            </.link>
            <.link navigate={~p"/about"} class="text-sm/6 font-semibold text-gray-900">
              Learn more <span aria-hidden="true">→</span>
            </.link>
          </div>
        </div>
      </div>

      <div class="prose text-left text-sm mb-10">
        Do you have questions or feedback? <.link href="mailto:greecex@amignosis.com?subject=Questions%20or%20feedback">Let us know</.link>.
      </div>
    </div>
    """
  end
end
