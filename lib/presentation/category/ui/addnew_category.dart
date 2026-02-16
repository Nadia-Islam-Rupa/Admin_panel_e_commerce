import 'dart:io';
import 'package:admin_pannel/data/category_data/category_provider.dart';
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
    final state = ref.watch(addCategoryProvider);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add New Category")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Name
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

            /// Button
            state.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (selectedImage == null) return;

                      await ref
                          .read(addCategoryProvider.notifier)
                          .addCategory(
                            name: nameController.text,
                            imageFile: selectedImage!,
                          );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Category"),
                  ),
          ],
        ),
      ),
    );
  }
}
