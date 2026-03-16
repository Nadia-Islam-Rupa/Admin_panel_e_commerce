import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient client;
  static const List<String> _productBucketCandidates = ["products", "product"];

  ProductRepository(this.client);

  Future<void> addProduct({
    required String name,
    required double price,
    required File imageFile,
    required String subCategoryId,
  }) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}";
      final imageUrl = await _uploadAndGetPublicUrl(
        file: imageFile,
        fileName: fileName,
      );

      await client.from("products").insert({
        "name": name,
        "price": price,
        "image_url": imageUrl,
        "sub_category_id": subCategoryId,
      });
    } on StorageException catch (e) {
      throw Exception("Product image upload failed: ${e.message}");
    } on PostgrestException catch (e) {
      throw Exception("Product insert failed: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected product add error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await client.from("products").select();
      return List<Map<String, dynamic>>.from(response);
    } on PostgrestException catch (e) {
      throw Exception("Fetch products failed: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected product fetch error: $e");
    }
  }

  Future<String> _uploadAndGetPublicUrl({
    required File file,
    required String fileName,
  }) async {
    StorageException? lastStorageError;

    for (final bucket in _productBucketCandidates) {
      try {
        await client.storage.from(bucket).upload(fileName, file);
        return client.storage.from(bucket).getPublicUrl(fileName);
      } on StorageException catch (e) {
        lastStorageError = e;

        final message = e.message.toLowerCase();
        final isBucketMissing =
            message.contains("bucket") && message.contains("not found");

        // Continue trying next known bucket name only for missing bucket errors.
        if (isBucketMissing) {
          continue;
        }

        rethrow;
      }
    }

    throw Exception(
      "Product image upload failed: storage bucket not found. "
      "Create one bucket named 'products' (or 'product') in Supabase Storage. "
      "Last error: ${lastStorageError?.message ?? 'unknown'}",
    );
  }
}
