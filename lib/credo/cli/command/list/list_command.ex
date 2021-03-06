defmodule Credo.CLI.Command.List.ListCommand do
  use Credo.CLI.Command

  @shortdoc "List all issues grouped by files"
  @moduledoc @shortdoc

  alias Credo.Execution
  alias Credo.CLI.Filter
  alias Credo.CLI.Command.List.ListOutput
  alias Credo.CLI.Task

  @doc false
  def call(%Execution{help: true} = exec, _opts),
    do: ListOutput.print_help(exec)

  def call(exec, _opts) do
    exec
    |> Task.LoadAndValidateSourceFiles.call()
    |> Task.PrepareChecksToRun.call()
    |> print_before_info()
    |> Task.RunChecks.call()
    |> Task.SetRelevantIssues.call()
    |> print_results_and_summary()
  end

  defp print_before_info(exec) do
    source_files =
      exec
      |> Execution.get_source_files()
      |> Filter.important(exec)

    ListOutput.print_before_info(source_files, exec)

    exec
  end

  defp print_results_and_summary(exec) do
    source_files = Execution.get_source_files(exec)

    time_load = Execution.get_assign(exec, "credo.time.source_files")
    time_run = Execution.get_assign(exec, "credo.time.run_checks")

    ListOutput.print_after_info(source_files, exec, time_load, time_run)

    exec
  end
end
