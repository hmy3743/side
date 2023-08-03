defmodule Core.Release do
  def migrate do
    Application.load(:core)
    {:ok, _, _} = Ecto.Migrator.with_repo(Core.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end
end
