class GetDeleteStatementsState {
  final dynamic error;
  final bool isLoading;
  final List<String> getDeleteAccountStatements;

  const GetDeleteStatementsState(
      {required this.isLoading,
      this.error,
      required this.getDeleteAccountStatements});

  factory GetDeleteStatementsState.initial() => const GetDeleteStatementsState(
      isLoading: false, getDeleteAccountStatements: []);
  factory GetDeleteStatementsState.isLoading() =>
      const GetDeleteStatementsState(
          isLoading: true, getDeleteAccountStatements: []);
  factory GetDeleteStatementsState.loaded(
          List<String> getDeleteAccountStatements) =>
      GetDeleteStatementsState(
          isLoading: false,
          getDeleteAccountStatements: getDeleteAccountStatements);
  factory GetDeleteStatementsState.error(dynamic error) =>
      GetDeleteStatementsState(
          isLoading: false, getDeleteAccountStatements: [], error: error);
}
