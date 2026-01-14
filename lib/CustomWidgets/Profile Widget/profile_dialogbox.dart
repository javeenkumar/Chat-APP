import 'package:chatapp/servies/provider/Bottom_nav_bar_provider/profile_images_Update_povider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDialogPickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Choose Image Source',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Consumer<ProfileImagesUpdatePovider>(builder: (context,provider,child){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  // Call your provider method here:
                  provider.pickImageGallery();
                  // provider.uploadImage();

                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                 provider.pickImageCamera();
                  // provider.uploadImage();
                },
              ),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}
