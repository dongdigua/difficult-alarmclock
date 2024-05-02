import Config

config :alarmclock, Alarmclock.Scheduler,
  timezone: "Asia/Shanghai",
  storage: QuantumStoragePersistentEts

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
