defmodule Alarmclock.Application do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Alarmclock.Router},
      Alarmclock.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Alarmclock.Supervisor]
    Logger.info("Starting alarmclock...")
    Supervisor.start_link(children, opts)
  end
end
