defmodule Mix.Tasks.GenTask do
  use Mix.Task

  @moduledoc """
  Generates new tasks

  Simply provide the filename and optionally a parent module.
  """

  require Logger

  @task_dir "/lib/mix/tasks"
  @default_parent_module Mix.Tasks

  def run([]), do: :error

  def run([filename]) do
    full_path = File.cwd!() <> @task_dir
    file_path = gen_file_path(filename, full_path)

    content =
      filename
      |> gen_module_name(nil)
      |> file_content()

    File.mkdir_p!(full_path)

    File.write(file_path, content)
  end

  def run([filename, parent_module]) do
    dir_path = build_dir_path(parent_module)
    file_path = gen_file_path(filename, dir_path)

    content =
      filename
      |> gen_module_name(parent_module)
      |> file_content()

    File.mkdir_p!(dir_path)

    File.write(file_path, content)
  end

  defp file_content(module_name) do
    """
    defmodule #{module_name} do
      use Mix.Task

      @moduledoc false

      def run([]), do: :error

    end
    """
  end

  defp build_dir_path(parent_module) do
    if String.contains?(parent_module, ".") do
      lib_subpath =
        parent_module
        |> String.split(".")
        |> Enum.map(&String.downcase/1)
        |> Enum.join("/")

      Path.join("#{File.cwd!()}/lib/", lib_subpath)
    else
      Path.join(["#{File.cwd!()}/lib/", String.downcase(parent_module)])
    end
  end

  defp gen_module_name(filename, nil),
    do: "Mix.Tasks.#{capitalize_filename(filename)}"

  defp gen_module_name(filename, parent),
    do: "Mix.Tasks.#{parent}.#{capitalize_filename(filename)}"

  defp capitalize_filename(filename),
    do:
      filename
      |> String.split("_")
      |> Enum.reduce("", fn
        str, acc -> acc <> String.capitalize(str)
      end)

  defp gen_file_path(filename, dir_path),
    do: Path.join(dir_path, "/#{filename}.ex")
end
