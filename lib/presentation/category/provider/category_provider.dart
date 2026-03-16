import 'dart:io';
import 'package:admin_pannel/data/category_data/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/supabase_provider.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return CategoryRepository(client);
});

/// Add Category
final addCategoryProvider =
    StateNotifierProvider<AddCategoryNotifier, AsyncValue<void>>((ref) {
      final repo = ref.watch(categoryRepositoryProvider);
      return AddCategoryNotifier(repo);
    });

class AddCategoryNotifier extends StateNotifier<AsyncValue<void>> {
  final CategoryRepository repository;

  AddCategoryNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> addCategory({
    required String name,
    required File imageFile,
  }) async {
    state = const AsyncValue.loading();

    try {
      await repository.addCategory(name: name, imageFile: imageFile);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Fetch Categories
final categoryListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.fetchCategories();
});
