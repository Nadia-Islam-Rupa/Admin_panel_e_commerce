import 'package:admin_pannel/data/category_data/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'category_card.dart';

class CategoryListPage extends ConsumerWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: categories.when(
        data: (data) => SizedBox(
          height: 200, // important for horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 👈 horizontal
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final category = data[index];

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryCard(
                  name: category['name'],
                  imageUrl: category['image_url'],
                  category: category,
                ),
              );
            },
          ),
        ),

        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
