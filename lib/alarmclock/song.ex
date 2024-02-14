defmodule Alarmclock.Song do
  def songs() do
    case File.ls("data") do
      {:ok, files} -> files
      _ -> ["no"]
    end
  end

  def play_song(song) do
    System.cmd("mpg123", ["-q", "--no-control", Path.join("data", song)])
  end
end
