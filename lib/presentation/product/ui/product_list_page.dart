import 'package:admin_pannel/presentation/product/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_card.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);

    return products.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text(
              'No products yet',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final product = data[index];

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ProductCard(product: product),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}
