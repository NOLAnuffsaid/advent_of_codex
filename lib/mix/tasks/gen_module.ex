defmodule Mix.Tasks.GenModule do
  use Mix.Task

  @moduledoc "Generates new modules"

  require Logger

  def run([]), do: :error

  def run([filename, parent_module]) do
    file_path = gen_file_path(parent_module)
    content = file_content(filename, parent_module)

    File.write(file_path, content)
  end

  defp file_content(filename, parent_module) do
    module_name = gen_module_name(filename)

    """
    defmodule #{parent_module}#{module_name} do
      @moduledoc false

      require Logger
    end
    """
  end

  defp gen_module_name(filename),
    do: filename |> String.split("_") |> Enum.map(&String.capitalize/1) |> Enum.join()

  defp gen_module_path(parent_module),
    do: parent_module |> String.split(".") |> Enum.join("/")

  defp gen_file_path(parent_module),
    do: "./lib/#{gen_module_path(parent_module)}"
end
