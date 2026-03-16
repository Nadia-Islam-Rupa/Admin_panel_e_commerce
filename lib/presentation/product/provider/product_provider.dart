import 'dart:io';
import 'package:admin_pannel/data/product/product_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/supabase_provider.dart';

final subCategoryProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final client = ref.watch(supabaseProvider);

  final data = await client.from("sub_category").select("id,name,category_id");

  return List<Map<String, dynamic>>.from(data);
});

final subCategoryByCategoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      categoryId,
    ) async {
      final client = ref.watch(supabaseProvider);

      final data = await client
          .from("sub_category")
          .select("id,name,category_id")
          .eq("category_id", categoryId);

      return List<Map<String, dynamic>>.from(data);
    });

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final client = ref.watch(supabaseProvider);
  return ProductRepository(client);
});

final addProductProvider =
    StateNotifierProvider<AddProductNotifier, AsyncValue<void>>((ref) {
      final repo = ref.watch(productRepositoryProvider);
      return AddProductNotifier(repo);
    });

final productListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchProducts();
});

class AddProductNotifier extends StateNotifier<AsyncValue<void>> {
  final ProductRepository repository;

  AddProductNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> addProduct({
    required String name,
    required double price,
    required File imageFile,
    required String subCategoryId,
  }) async {
    state = const AsyncValue.loading();

    try {
      await repository.addProduct(
        name: name,
        price: price,
        imageFile: imageFile,
        subCategoryId: subCategoryId,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
