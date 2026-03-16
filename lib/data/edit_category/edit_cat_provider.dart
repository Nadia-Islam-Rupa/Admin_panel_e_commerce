import 'package:admin_pannel/presentation/category/provider/category_provider.dart';
import 'package:admin_pannel/data/category_data/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final updateCategoryProvider =
    StateNotifierProvider<UpdateCategoryNotifier, AsyncValue<void>>((ref) {
      final repo = ref.watch(categoryRepositoryProvider);
      return UpdateCategoryNotifier(repo);
    });

class UpdateCategoryNotifier extends StateNotifier<AsyncValue<void>> {
  final CategoryRepository repository;

  UpdateCategoryNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> updateCategory({
    required String id,
    required String name,
  }) async {
    state = const AsyncValue.loading();

    try {
      await repository.updateCategory(id: id, name: name);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
