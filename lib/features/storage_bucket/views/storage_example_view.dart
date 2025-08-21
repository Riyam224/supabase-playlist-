// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_playlist/core/helper/supabase_helper.dart';

class SupabaseStorageExample extends StatefulWidget {
  const SupabaseStorageExample({super.key});

  @override
  State<SupabaseStorageExample> createState() => _SupabaseStorageExampleState();
}

class _SupabaseStorageExampleState extends State<SupabaseStorageExample> {
  String? uploadedImageUrl; // Public URL for displaying
  String? uploadedImagePath; // Path inside bucket (needed for delete)

  /// Pick image from gallery
  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return File(image.path);
  }

  /// Upload image to Supabase
  Future<void> uploadImage() async {
    final imageFile = await pickImage();
    if (imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No image selected")));
      return;
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final uniquePath = "uploads/$timestamp-${imageFile.path.split('/').last}";

      // ✅ Upload to Supabase Storage
      await SupabaseHelper.client.storage
          .from('avatars')
          .upload(uniquePath, imageFile);

      // ✅ Get public URL
      final publicUrl = SupabaseHelper.client.storage
          .from('avatars')
          .getPublicUrl(uniquePath);

      setState(() {
        uploadedImageUrl = publicUrl;
        uploadedImagePath = uniquePath;
      });
    } catch (e) {
      debugPrint("Upload error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  /// Delete image from Supabase
  Future<void> deleteImage() async {
    if (uploadedImagePath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No image to delete")));
      return;
    }

    try {
      await SupabaseHelper.client.storage.from('avatars').remove([
        uploadedImagePath!,
      ]);

      setState(() {
        uploadedImageUrl = null;
        uploadedImagePath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image deleted successfully")),
      );
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supabase Storage Example"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            uploadedImageUrl == null
                ? const Text("No image uploaded")
                : Image.network(
                    uploadedImageUrl!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text("Upload Image"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteImage,
              child: const Text("Delete Image"),
            ),
          ],
        ),
      ),
    );
  }
}
