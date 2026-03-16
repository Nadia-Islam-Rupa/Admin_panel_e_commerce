import 'dart:io';
import 'package:admin_pannel/presentation/category/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final nameController = TextEditingController();
  File? selectedImage;

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        setState(() {
          selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addCategoryProvider);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add New Category")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Category Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Category Name",
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

            /// Loading Indicator
            if (state.isLoading) const CircularProgressIndicator(),

            /// Add Button
            if (!state.isLoading)
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Category name required")),
                    );
                    return;
                  }

                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select image")),
                    );
                    return;
                  }

                  try {
                    debugPrint("Calling addCategory...");

                    await ref
                        .read(addCategoryProvider.notifier)
                        .addCategory(
                          name: nameController.text.trim(),
                          imageFile: selectedImage!,
                        );

                    debugPrint("Category added successfully");

                    ref.invalidate(categoryListProvider);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    debugPrint("UI ERROR: $e");

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: const Text("Add Category"),
              ),

            /// Show Error Text (from Riverpod)
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  state.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
