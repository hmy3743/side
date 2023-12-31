defmodule ShadowChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ShadowChatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ShadowChat.PubSub},
      # Start Finch
      {Finch, name: ShadowChat.Finch},
      # Start the Endpoint (http/https)
      ShadowChatWeb.Endpoint,
      # Start a worker by calling: ShadowChat.Worker.start_link(arg)
      # {ShadowChat.Worker, arg}
      {ShadowChat.QuotaCounter, 100}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShadowChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShadowChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
