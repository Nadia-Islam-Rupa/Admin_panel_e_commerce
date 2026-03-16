import 'dart:io';
import 'package:admin_pannel/presentation/category/provider/category_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/product_provider.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  File? selectedImage;

  String? selectedCategoryId;
  String? selectedSubCategoryId;

  @override
  void initState() {
    super.initState();

    // Always load the latest category and subcategory rows when opening form.
    Future.microtask(() {
      ref.invalidate(categoryListProvider);
      ref.invalidate(subCategoryProvider);
    });
  }

  String? _normalizeId(dynamic value) {
    if (value == null) {
      return null;
    }

    // Handles possible relation object payloads from Supabase selects.
    if (value is Map<String, dynamic>) {
      return value["id"]?.toString();
    }

    return value.toString();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductProvider);
    final categories = ref.watch(categoryListProvider);
    final selectedSubCategoriesAsync = selectedCategoryId == null
        ? const AsyncValue.data(<Map<String, dynamic>>[])
        : ref.watch(subCategoryByCategoryProvider(selectedCategoryId!));

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add Product")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Product Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// Category Dropdown
            categories.when(
              data: (data) {
                return DropdownButtonFormField<String>(
                  hint: const Text("Select Category"),
                  initialValue: selectedCategoryId,
                  items: data
                      .map((category) {
                        final categoryId = _normalizeId(category["id"]);

                        if (categoryId == null) {
                          return null;
                        }

                        return DropdownMenuItem<String>(
                          value: categoryId,
                          child: Text(category["name"]),
                        );
                      })
                      .whereType<DropdownMenuItem<String>>()
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                      selectedSubCategoryId = null;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const SizedBox(height: 15),

            /// Sub Category Dropdown
            selectedSubCategoriesAsync.when(
              data: (data) {
                return DropdownButtonFormField<String>(
                  key: ValueKey(selectedCategoryId),
                  hint: const Text("Select Sub Category"),
                  disabledHint: const Text("Select Category First"),
                  initialValue: selectedSubCategoryId,
                  items: data
                      .map((sub) {
                        final subCategoryId = _normalizeId(sub["id"]);

                        if (subCategoryId == null) {
                          return null;
                        }

                        return DropdownMenuItem<String>(
                          value: subCategoryId,
                          child: Text(sub["name"]),
                        );
                      })
                      .whereType<DropdownMenuItem<String>>()
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubCategoryId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const SizedBox(height: 15),

            /// Price
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// Image Picker
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage == null
                    ? const Center(child: Text("Select Image"))
                    : Image.file(selectedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            if (state.isLoading) const CircularProgressIndicator(),

            if (!state.isLoading)
              ElevatedButton(
                onPressed: () async {
                  final productName = nameController.text.trim();
                  final parsedPrice = double.tryParse(priceController.text);

                  if (productName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Product name is required")),
                    );
                    return;
                  }

                  if (parsedPrice == null || parsedPrice <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a valid price")),
                    );
                    return;
                  }

                  if (selectedSubCategoryId == null || selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Select category, subcategory and image"),
                      ),
                    );
                    return;
                  }

                  try {
                    await ref
                        .read(addProductProvider.notifier)
                        .addProduct(
                          name: productName,
                          price: parsedPrice,
                          imageFile: selectedImage!,
                          subCategoryId: selectedSubCategoryId!,
                        );

                    ref.invalidate(productListProvider);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Product added successfully"),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text("Add Product"),
              ),
          ],
        ),
      ),
    );
  }
}
