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

      final response = await client.storage
          .from('category')
          .upload(fileName, file);

      final imageUrl = client.storage.from('category').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }

  /// Insert category
  Future<void> addCategory({
    required String name,
    required File imageFile,
  }) async {
    try {
      print("Starting addCategory...");

      final imageUrl = await uploadImage(imageFile);

      print("Inserting into database...");

      final response = await client.from('category').insert({
        'name': name,
        'image_url': imageUrl,
      }).select();

      print("Insert response: $response");
    } catch (e) {
      print("INSERT ERROR: $e");
      rethrow;
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
    } catch (e) {
      print("FETCH ERROR: $e");
      rethrow;
    }
  }
}
