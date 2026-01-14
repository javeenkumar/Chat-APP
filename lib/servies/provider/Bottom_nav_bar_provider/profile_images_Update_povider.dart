import 'dart:io';

import 'package:chatapp/CustomWidgets/Utilities/ToastMessage.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:image/image.dart' as img;

class ProfileImagesUpdatePovider with ChangeNotifier {

  final _ref = FirebaseDatabase.instance.ref('user');

  bool _isLoading = false;
  File? _image;
  String? _uploadedUrl;

  final ImagePicker _picker = ImagePicker();
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'duxfaiu8k',
    'flutter_unsigned',
    cache: false,
  );

  bool get isLoading => _isLoading;
  File? get image => _image;

  String? get uploadedUrl => _uploadedUrl;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Pick image from gallery
  Future<void> pickImageGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      uploadImage();
      notifyListeners();

    }
  }

  Future<void> pickImageCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      uploadImage();
      notifyListeners();

    }
  }


  File compressImage(File file) {
    final image = img.decodeImage(file.readAsBytesSync())!;
    final resized = img.copyResize(image, width: 800);
    return File(file.path)..writeAsBytesSync(img.encodeJpg(resized, quality: 80));
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      print('No image selected!');
      return;
    }

    _setLoading(true);
    try {

      File compressedFile = compressImage(_image!);

      print('Uploading image: ${_image!.path}+++${compressedFile.path}');

      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          compressedFile.path,
          folder: 'profile_images',
        ),
      );

      _uploadedUrl = response.secureUrl;
      updateProfileImage(SessionController.userId.toString(),_uploadedUrl.toString());
      print('Upload Success: $_uploadedUrl');

    } catch (e) {
      print('Upload failed: $e');
      _uploadedUrl = null;
    } finally {
      _setLoading(false);
    }

    notifyListeners();
  }


  Future<void> updateProfileImage(String userId, String imageUrl) async {
    _setLoading(true);
    try {
      await _ref.child(userId).update({'profile': imageUrl});
      ToastMessage("Profile Upload", false);
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      ToastMessage("Profile image update failed: $e", true);
      print("Profile image update failed: $e");
      rethrow;
    }
  }

}
