defmodule Alarmclock.Router do
  import Alarmclock.Alarm
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
          case conn.params["type"] do
            "+" -> add_alarm(expr, song)
            "»" -> add_oneshot_alarm(expr, song)
          end
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

  post "/api/pkill" do
    Alarmclock.Song.pkill()
    conn
    |> put_resp_header("location", "/")
    |> send_resp(302, "")
  end


  def render_html() do
    EEx.eval_file("index.eex", alarms: generate_alarm_list(), songs: Alarmclock.Song.songs())
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
