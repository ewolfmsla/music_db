# ---
# Excerpted from "Programming Ecto",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wmecto for more book information.
# ---
defmodule MusicDB.MixProject do
  use Mix.Project

  def project do
    [
      app: :music_db,
      version: "0.1.0",
      elixir: "~> 1.13.2",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      xref: [exclude: [:ssl]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MusicDB.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.7"},
      {:postgrex, "~> 0.16.2"},
      {:mariaex, "~> 0.9.1"},
      {:json, "~> 1.4"},
      {:polymorphic_embed, "~> 1.9"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
