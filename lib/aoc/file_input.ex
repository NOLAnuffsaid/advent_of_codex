defmodule AOC.FileInput do
  @moduledoc false

  require IEx

  @doc """
  Parses challenge input files.
  """
  def parse(file_path, opts \\ []) when is_binary(file_path) and byte_size(file_path) > 0 do
    File.stream!(file_path)
  end

  def parse(file_path, as: :stream) when is_binary(file_path) and byte_size(file_path) > 0 do
    File.stream!(file_path, [], 1)
  end

  def parse(_, _), do: {:error, :invalidargs}
end
