import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient client;

  CategoryRepository(this.client);

  /// Upload image to Supabase Storage
  Future<String> uploadImage(File file) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}";

    await client.storage.from('category-images').upload(fileName, file);

    final imageUrl = client.storage
        .from('category-images')
        .getPublicUrl(fileName);

    return imageUrl;
  }

  /// Insert category
  Future<void> addCategory({
    required String name,
    required File imageFile,
  }) async {
    final imageUrl = await uploadImage(imageFile);

    await client.from('category').insert({'name': name, 'image_url': imageUrl});
  }

  /// Fetch all categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await client
        .from('category')
        .select()
        .order('created_at', ascending: false);

    return response;
  }
}
