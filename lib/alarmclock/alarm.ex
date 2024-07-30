defmodule Alarmclock.Alarm do
  require Logger
  def add_alarm(cron, song) do
    name = Alarmclock.Atompool.alloc()
    Alarmclock.Scheduler.new_job()
    |> Quantum.Job.set_name(name)
    |> Quantum.Job.set_schedule(cron)
    |> Quantum.Job.set_task(fn -> Alarmclock.Song.play_song(song) end)
    |> Alarmclock.Scheduler.add_job()
  end

  def add_oneshot_alarm(cron, song) do
    name = Alarmclock.Atompool.alloc()
    Alarmclock.Scheduler.new_job()
    |> Quantum.Job.set_name(name)
    |> Quantum.Job.set_schedule(cron)
    |> Quantum.Job.set_task(fn ->
      Alarmclock.Song.play_song(song)
      Alarmclock.Scheduler.delete_job(name)
      Alarmclock.Atompool.dealloc(name)
    end)
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
end
