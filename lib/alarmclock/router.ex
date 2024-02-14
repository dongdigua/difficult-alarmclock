defmodule Alarmclock.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  get "/" do
    f = render_html()
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
            if song in Alarmclock.Song.songs(), do: add_alarm(expr, song)
        end
      delete != nil ->
        Alarmclock.Scheduler.delete_job(String.to_atom(delete))
      true -> nil
    end
    f = render_html()
    send_resp(conn, 200, f)
  end

  def add_alarm(cron, song) do
    n = Alarmclock.Scheduler.jobs() |> Enum.count()
    Alarmclock.Scheduler.new_job()
    |> Quantum.Job.set_name(:"#{n}")
    |> Quantum.Job.set_schedule(cron)
    |> Quantum.Job.set_task(fn -> Alarmclock.Song.play_song(song) end)
    |> Alarmclock.Scheduler.add_job()
  end

  def generate_alarm_list() do
    Alarmclock.Scheduler.jobs()
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.map(fn x -> {inspect(x.schedule), Atom.to_string(x.name)} end)
  end

  def render_html() do
    EEx.eval_file("index.eex", alarms: generate_alarm_list(), songs: Alarmclock.Song.songs())
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
