import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient client;

  CategoryRepository(this.client);

  Future<void> addCategory({
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    await client.from('categories').insert({
      'name': name,
      'description': description,
      'image_url': imageUrl,
    });
  }
}
