import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research_mantra_official/data/repositories/interfaces/IUser_repository.dart';
import 'package:research_mantra_official/main.dart';
import 'package:research_mantra_official/providers/delete_account/delete_account_statement_state.dart';

// Notifier Class for Managing Delete Statements State
class GetDeleteStatementsNotifier
    extends StateNotifier<GetDeleteStatementsState> {
  // Dependency Injection via Constructor
  GetDeleteStatementsNotifier(this._iUserRepository)
      : super(GetDeleteStatementsState.initial());

  final IUserRepository _iUserRepository;

  // Method to Fetch Delete Account Statements
  Future<void> getAllTheDeleteAccountStatements() async {
    try {
      // Set state to loading while fetching data
      state = GetDeleteStatementsState.isLoading();

      // Fetch the statements from the repository
      final dynamic statements = await _iUserRepository.getDeleteStatements();

      // Update the state with the fetched statements
      state = GetDeleteStatementsState.loaded(statements);
    } catch (e, stacktrace) {
      // Handle error and log stacktrace for debugging
      state = GetDeleteStatementsState.error([]);
      print("Error fetching delete account statements: $e\n$stacktrace");
    }
  }
}

// Provider for accessing the GetDeleteStatementsNotifier
final getDeleteAccountStatementsProvider = StateNotifierProvider<
    GetDeleteStatementsNotifier, GetDeleteStatementsState>((ref) {
  final IUserRepository userRepository = getIt<IUserRepository>();
  return GetDeleteStatementsNotifier(userRepository);
});
