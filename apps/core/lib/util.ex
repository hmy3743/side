defmodule Util do
  def path_in_priv(path, app \\ :core) do
    :code.priv_dir(app)
    |> Path.join(path)
  end

  def read_data(path, app \\ :core) do
    path_in_priv(path, app)
    |> YamlElixir.read_from_file!()
  end
end
