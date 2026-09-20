%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/", "config/"],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/"]
      },
      plugins: [{ExSlop, []}],
      requires: [],
      strict: false,
      parse_timeout: 5000,
      color: true,
      checks: %{
        # ExSlop's own curated set, rather than a copy of it that goes
        # stale. The hand-written list this replaces was the recommended
        # bundle as of 0.4.1 and had already fallen a check behind.
        #
        # The checks it leaves out are opt-in by ExSlop's choice, not by
        # ours. They are the ones it found noisy on mature codebases.
        enabled:
          [
            {Credo.Check.Consistency.ExceptionNames, []},
            {Credo.Check.Consistency.LineEndings, []},
            {Credo.Check.Consistency.ParameterPatternMatching, []},
            {Credo.Check.Consistency.SpaceAroundOperators, []},
            {Credo.Check.Consistency.SpaceInParentheses, []},
            {Credo.Check.Consistency.TabsOrSpaces, []},
            {Credo.Check.Design.AliasUsage,
             [priority: :low, if_nested_deeper_than: 2, if_called_more_often_than: 0]},
            {Credo.Check.Design.TagFIXME, []},
            {Credo.Check.Design.TagTODO, [exit_status: 2]},
            {Credo.Check.Readability.AliasOrder, []},
            {Credo.Check.Readability.FunctionNames, []},
            {Credo.Check.Readability.LargeNumbers, []},
            {Credo.Check.Readability.MaxLineLength, [priority: :low, max_length: 120]},
            {Credo.Check.Readability.ModuleAttributeNames, []},
            {Credo.Check.Readability.ModuleDoc, []},
            {Credo.Check.Readability.ModuleNames, []},
            {Credo.Check.Readability.ParenthesesInCondition, []},
            {Credo.Check.Readability.ParenthesesOnZeroArityDefs, []},
            {Credo.Check.Readability.PipeIntoAnonymousFunctions, []},
            {Credo.Check.Readability.PredicateFunctionNames, []},
            {Credo.Check.Readability.PreferImplicitTry, []},
            {Credo.Check.Readability.RedundantBlankLines, []},
            {Credo.Check.Readability.Semicolons, []},
            {Credo.Check.Readability.SpaceAfterCommas, []},
            {Credo.Check.Readability.StringSigils, []},
            {Credo.Check.Readability.TrailingBlankLine, []},
            {Credo.Check.Readability.TrailingWhiteSpace, []},
            {Credo.Check.Readability.UnnecessaryAliasExpansion, []},
            {Credo.Check.Readability.VariableNames, []},
            {Credo.Check.Readability.WithSingleClause, []},
            {Credo.Check.Refactor.AppendSingleItem, []},
            {Credo.Check.Refactor.Apply, []},
            {Credo.Check.Refactor.CondStatements, []},
            {Credo.Check.Refactor.CyclomaticComplexity, []},
            {Credo.Check.Refactor.DoubleBooleanNegation, []},
            {Credo.Check.Refactor.FilterCount, []},
            {Credo.Check.Refactor.FilterFilter, []},
            {Credo.Check.Refactor.FunctionArity, []},
            {Credo.Check.Refactor.LongQuoteBlocks, []},
            {Credo.Check.Refactor.MapJoin, []},
            {Credo.Check.Refactor.MapMap, []},
            {Credo.Check.Refactor.MatchInCondition, []},
            {Credo.Check.Refactor.NegatedConditionsInUnless, []},
            {Credo.Check.Refactor.NegatedConditionsWithElse, []},
            {Credo.Check.Refactor.NegatedIsNil, []},
            {Credo.Check.Refactor.Nesting, []},
            {Credo.Check.Refactor.PassAsyncInTestCases, []},
            {Credo.Check.Refactor.RedundantWithClauseResult, []},
            {Credo.Check.Refactor.RejectReject, []},
            {Credo.Check.Refactor.UnlessWithElse, []},
            {Credo.Check.Refactor.WithClauses, []},
            {Credo.Check.Warning.ApplicationConfigInModuleAttribute, []},
            {Credo.Check.Warning.BoolOperationOnSameValues, []},
            {Credo.Check.Warning.Dbg, []},
            {Credo.Check.Warning.ExpensiveEmptyEnumCheck, []},
            {Credo.Check.Warning.IExPry, []},
            {Credo.Check.Warning.IoInspect, []},
            {Credo.Check.Warning.LeakyEnvironment, []},
            {Credo.Check.Warning.MapGetUnsafePass, []},
            {Credo.Check.Warning.MissedMetadataKeyInLoggerConfig, []},
            {Credo.Check.Warning.OperationOnSameValues, []},
            {Credo.Check.Warning.OperationWithConstantResult, []},
            {Credo.Check.Warning.RaiseInsideRescue, []},
            {Credo.Check.Warning.SpecWithStruct, []},
            {Credo.Check.Warning.StructFieldAmount, []},
            {Credo.Check.Warning.UnsafeExec, []},
            {Credo.Check.Warning.UnusedEnumOperation, []},
            {Credo.Check.Warning.UnusedFileOperation, []},
            {Credo.Check.Warning.UnusedKeywordOperation, []},
            {Credo.Check.Warning.UnusedListOperation, []},
            {Credo.Check.Warning.UnusedMapOperation, []},
            {Credo.Check.Warning.UnusedPathOperation, []},
            {Credo.Check.Warning.UnusedRegexOperation, []},
            {Credo.Check.Warning.UnsafeToAtom, []},
            {Credo.Check.Warning.UnusedStringOperation, []},
            {Credo.Check.Warning.UnusedTupleOperation, []},
            {Credo.Check.Warning.WrongTestFilename, []}
          ] ++
            Enum.map(ExSlop.recommended_checks(), fn
              # `length(x) == 2` is the clearest way to assert an exact count,
              # and the traversal this check objects to costs nothing on a
              # fixture. Some of ours count 14 and 1_005, which no pattern
              # match expresses. Scoped rather than disabled, because the same
              # comparison in running code is worth catching.
              ExSlop.Check.Refactor.LengthComparison = check ->
                {check, files: %{excluded: ["test/"]}}

              check ->
                {check, []}
            end),
        disabled: []
      }
    }
  ]
}
