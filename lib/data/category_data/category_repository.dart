import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient client;

  CategoryRepository(this.client);

  /// Upload image
  Future<String> uploadImage(File file) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}";

      await client.storage.from('category').upload(fileName, file);

      final imageUrl = client.storage.from('category').getPublicUrl(fileName);

      return imageUrl;
    } on StorageException catch (e) {
      throw Exception("Image upload failed: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected upload error: $e");
    }
  }

  /// Insert category
  Future<void> addCategory({
    required String name,
    required File imageFile,
  }) async {
    try {
      final imageUrl = await uploadImage(imageFile);

      await client.from('category').insert({
        'name': name,
        'image_url': imageUrl,
      });
    } on PostgrestException catch (e) {
      throw Exception("Database insert failed: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected insert error: $e");
    }
  }

  /// Fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await client
          .from('category')
          .select()
          .order('created_at', ascending: false);

      return response;
    } on PostgrestException catch (e) {
      throw Exception("Fetch failed: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected fetch error: $e");
    }
  }

  /// ✅ Update category
  Future<void> updateCategory({
    required String id,
    required String name,
  }) async {
    try {
      await client.from('category').update({'name': name}).eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception("Update failed: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected update error: $e");
    }
  }
}
