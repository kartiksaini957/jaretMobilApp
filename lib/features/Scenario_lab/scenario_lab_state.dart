/// Which preview state the Scenario Lab screen is showing.
enum ScenarioViewState { results, empty, loading }

extension ScenarioViewStateLabel on ScenarioViewState {
  String get label => switch (this) {
    ScenarioViewState.results => 'Results',
    ScenarioViewState.empty => 'Empty',
    ScenarioViewState.loading => 'Loading',
  };
}
