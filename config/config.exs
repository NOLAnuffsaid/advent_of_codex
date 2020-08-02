use Mix.Config

config :mix_test_watch,
  tasks: ["format", "credo --strict"],
  clear: true,
  exclude: [~r/apps\/*\/test\/support\//]
