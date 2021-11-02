import 'package:flutter_boilerplate/app/provider/app_start_provider.dart';
import 'package:flutter_boilerplate/app/state/app_start_state.dart';
import 'package:flutter_boilerplate/feature/home/repository/books_repository.dart';
import 'package:flutter_boilerplate/feature/home/state/books_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final booksProvider = StateNotifierProvider<BooksProvider, BooksState>((ref) {
  final appStartState = ref.watch(appStartProvider);

  return BooksProvider(ref.read, appStartState);
});

class BooksProvider extends StateNotifier<BooksState> {
  final Reader _reader;
  final AppStartState _appStartState;

  late final BooksRepository _repository = _reader(booksRepositoryProvider);

  BooksProvider(this._reader, this._appStartState)
      : super(const BooksState.loading()) {
    _init();
  }

  _init() async {
    _appStartState.maybeWhen(
        authenticated: () {
          _fetchBooks();
        },
        orElse: () {});
  }

  _fetchBooks() async {
    final response = await _repository.fetchBooks();
    if (mounted) {
      state = response;
    }
  }
}
