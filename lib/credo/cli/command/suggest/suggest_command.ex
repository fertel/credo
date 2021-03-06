defmodule Credo.CLI.Command.Suggest.SuggestCommand do
  use Credo.CLI.Command

  @shortdoc "Suggest code objects to look at next (default)"

  alias Credo.Execution
  alias Credo.CLI.Command.Suggest.SuggestOutput
  alias Credo.CLI.Task

  @doc false
  def call(%Execution{help: true} = exec, _opts),
    do: SuggestOutput.print_help(exec)

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
    source_files = Execution.get_source_files(exec)

    SuggestOutput.print_before_info(source_files, exec)

    exec
  end

  defp print_results_and_summary(%Execution{} = exec) do
    source_files = Execution.get_source_files(exec)

    time_load = Execution.get_assign(exec, "credo.time.source_files")
    time_run = Execution.get_assign(exec, "credo.time.run_checks")

    SuggestOutput.print_after_info(source_files, exec, time_load, time_run)

    exec
  end
end
