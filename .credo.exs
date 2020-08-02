%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces},
        {Credo.Check.Readability.MaxLineLength, max_length: 175},
        {Credo.Check.Refactor.FunctionArity, priorty: :high},
        {Credo.Check.Refactor.PipeChainStart, priorty: :high},
        {Credo.Check.Refactor.PerceivedComplexity, priorty: :high},
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false}
      ]
    }
  ]
}

