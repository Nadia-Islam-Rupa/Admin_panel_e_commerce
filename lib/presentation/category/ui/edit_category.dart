import 'package:admin_pannel/data/category_data/category_provider.dart';
import 'package:admin_pannel/data/edit_category/edit_cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCategory extends ConsumerStatefulWidget {
  final Map<String, dynamic> category;

  const EditCategory({super.key, required this.category});

  @override
  ConsumerState<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends ConsumerState<EditCategory> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category['name']);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text('Edit Category'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(updateCategoryProvider.notifier)
                    .updateCategory(
                      id: widget.category['id'],
                      name: nameController.text,
                    );

                /// refresh category list
                ref.invalidate(categoryListProvider);

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
