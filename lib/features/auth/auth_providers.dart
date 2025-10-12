import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kEntryIdKey = 'entry_id';

final prefsProvider = FutureProvider<SharedPreferences>(
      (ref) async => SharedPreferences.getInstance(),
);

final entryIdProvider = StateNotifierProvider<EntryIdController, int?>((ref) {
  return EntryIdController(ref);
});

class EntryIdController extends StateNotifier<int?> {
  EntryIdController(this._ref) : super(null) {
    _load();
  }
  final Ref _ref;

  Future<void> _load() async {
    final prefs = await _ref.read(prefsProvider.future);
    state = prefs.getInt(_kEntryIdKey);
  }

  Future<void> setEntryId(int id) async {
    state = id;
    final prefs = await _ref.read(prefsProvider.future);
    await prefs.setInt(_kEntryIdKey, id);
  }

  Future<void> clear() async {
    state = null;
    final prefs = await _ref.read(prefsProvider.future);
    await prefs.remove(_kEntryIdKey);
  }
}

final isOnboardedProvider = Provider<bool>((ref) => ref.watch(entryIdProvider) != null);