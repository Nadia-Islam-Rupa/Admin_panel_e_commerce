import 'package:admin_pannel/core/supabase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<int> _countRows(Ref ref, String table) async {
  final client = ref.watch(supabaseProvider);
  final rows = await client.from(table).select('id');
  return rows.length;
}

Future<int> _countFromCandidates(Ref ref, List<String> candidates) async {
  for (final table in candidates) {
    try {
      return await _countRows(ref, table);
    } catch (_) {
      // Keep trying fallback table names.
    }
  }

  // If no user table exists yet, show 0 users instead of an error.
  return 0;
}

final totalCategoryCountProvider = FutureProvider<int>((ref) async {
  return _countRows(ref, 'category');
});

final totalProductCountProvider = FutureProvider<int>((ref) async {
  return _countRows(ref, 'products');
});

final totalUserCountProvider = FutureProvider<int>((ref) async {
  // Uses common table names for app users and falls back automatically.
  return _countFromCandidates(ref, ['users', 'profiles', 'user']);
});
