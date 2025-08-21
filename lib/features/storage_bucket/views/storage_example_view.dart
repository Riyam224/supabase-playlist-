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
  String? uploadedImageUrl; // will hold the uploaded image link

  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null; // User canceled the picker
    }
    final File imageFile = File(image.path);
    return imageFile;
  }

  Future<void> uploadImage() async {
    final imageFile = await pickImage();
    if (imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No image selected")));
      return;
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final uniqueImagePath = '${timestamp}_${imageFile.path.split('/').last}';
    await SupabaseHelper.client.storage
        .from('avatars')
        .upload(uniqueImagePath, imageFile);
    // setState(() {
    //   uploadedImageUrl = "https://via.placeholder.com/150"; // demo placeholder
    // });
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
                : Image.network(uploadedImageUrl!, height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text("Upload Image"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Delete Image")),
          ],
        ),
      ),
    );
  }
}
