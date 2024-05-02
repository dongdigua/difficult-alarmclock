defmodule Alarmclock.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Static, from: ".", at: "/", only: ~w(favicon.ico)
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  get "/" do
    f = render_html()
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, f)
  end

  post "/api/add" do
    cron = conn.params["cron"]
    song = conn.params["song"]
    if  cron != nil and song in Alarmclock.Song.songs() do
      case Crontab.CronExpression.Parser.parse(cron) do
        {:ok, expr} ->
          add_alarm(expr, song)
      end
    end
    conn
   |> put_resp_header("location", "/")
   |> send_resp(302, "")
  end

  post "/api/del" do
    delete = conn.params["delete"]
    delete_alarm(String.to_existing_atom(delete))
    conn
    |> put_resp_header("location", "/")
    |> send_resp(302, "")
  end

  def add_alarm(cron, song) do
    name = Alarmclock.Atompool.alloc()
    Alarmclock.Scheduler.new_job()
    |> Quantum.Job.set_name(name)
    |> Quantum.Job.set_schedule(cron)
    |> Quantum.Job.set_task(fn -> Alarmclock.Song.play_song(song) end)
    |> Alarmclock.Scheduler.add_job()
  end

  def delete_alarm(alarm) do
    Alarmclock.Scheduler.delete_job(alarm)
    Alarmclock.Atompool.dealloc(alarm)
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
