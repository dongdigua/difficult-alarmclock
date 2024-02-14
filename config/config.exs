import Config

config :alarmclock, Alarmclock.Scheduler,
  timezone: "Asia/Shanghai"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
