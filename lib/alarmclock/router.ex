defmodule Alarmclock.Router do
  use Plug.Router
  import Crontab.CronExpression

  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  get "/" do
    f = EEx.eval_file("index.eex", alarms: generate_alarm_list())
    send_resp(conn, 200, f)
  end

  post "/" do
    cron = conn.params["cron"]
    song = conn.params["song"]
    delete = conn.params["delete"]
    cond do
      cron != nil and song != nil ->
        case Crontab.CronExpression.Parser.parse(cron) do
          {:ok, expr} -> 
            add_job(expr, song)
        end
      delete != nil ->
        IO.puts(delete)
      true -> nil
    end
    f = EEx.eval_file("index.eex", alarms: generate_alarm_list())
    send_resp(conn, 200, f)
  end

  def add_job(cron, song) do
    n = Alarmclock.Scheduler.jobs() |> Enum.count()
    Alarmclock.Scheduler.new_job()
    |> Quantum.Job.set_name(:"#{n}")
    |> Quantum.Job.set_schedule(cron)
    |> Quantum.Job.set_task(fn -> do_song(song) end)
    |> Alarmclock.Scheduler.add_job()
  end

  def do_song(song) do
    IO.puts(song)
  end

  def generate_alarm_list() do
    Alarmclock.Scheduler.jobs()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.map(fn x -> {inspect(x.schedule), Atom.to_string(x.name)} end)
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
