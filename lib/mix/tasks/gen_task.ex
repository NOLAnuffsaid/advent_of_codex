defmodule Mix.Tasks.GenTask do
  use Mix.Task

  @moduledoc """
  Generates new tasks

  Simply provide the filename and optionally a parent module.
  """

  require Logger

  @task_dir "/lib/mix/tasks"
  @default_parent_module "Mix.Tasks"

  def run([]), do: :error

  def run([filename]) do
    full_path = File.cwd!() <> @task_dir

    File.mkdir_p!(full_path)

    File.write(
      gen_file_path(filename, full_path),
      compile_content(filename, nil)
    )
  end

  def run([filename, module]) do
    dir_path = build_dir_path(module)

    File.mkdir_p!(dir_path)

    File.write(
      gen_file_path(filename, dir_path),
      compile_content(filename, module)
    )
  end

  defp compile_content(filename, module),
    do:
      filename
      |> gen_module_name(module)
      |> file_content()

  defp file_content(module_name) do
    """
    defmodule #{module_name} do
      use Mix.Task

      @moduledoc false

      def run([]), do: :error

    end
    """
  end

  defp build_dir_path(module),
    do: if(module =~ ".", do: deep_path(module), else: simple_path(module))

  defp deep_path(module),
    do:
      module
      |> module_to_path()
      |> join_path()

  defp simple_path(module),
    do:
      module
      |> String.downcase()
      |> join_path()

  defp module_to_path(module),
    do:
      module
      |> String.split(".")
      |> Enum.map(&String.downcase/1)
      |> Enum.join("/")

  defp join_path(subpath),
    do: Path.join("#{File.cwd!()}#{@task_dir}", subpath)

  defp gen_module_name(filename, nil),
    do: "#{@default_parent_module}.#{capitalize_filename(filename)}"

  defp gen_module_name(filename, parent),
    do: "#{@default_parent_module}.#{parent}.#{capitalize_filename(filename)}"

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
