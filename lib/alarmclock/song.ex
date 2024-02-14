defmodule Alarmclock.Song do
  def songs() do
    case File.ls("data") do
      {:ok, files} -> ["random" | files]
      _ -> ["no"]
    end
  end

  def play_song(song) do
    to_play = case song do
                "random" -> Enum.random(tl(songs()))
                _ -> song
              end
    System.cmd("mpg123", ["-q", "--no-control", Path.join("data", to_play)])
  end
end
