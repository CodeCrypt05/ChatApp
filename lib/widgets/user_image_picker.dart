import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

// picking image from camera
  void _imgFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

// picking image from gallery
  void _imgFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  void _showImagePicker(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: ctx,
        builder: (context) {
          return Container(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6.2,
              margin: const EdgeInsets.only(top: 2.0),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 28),
                      child: Text(
                        'Profile Photo',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Icon(Icons.image, size: 40.0),
                            SizedBox(height: 12.0),
                            Text(
                              'Gallery',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Icon(Icons.camera, size: 40.0),
                            SizedBox(height: 12.0),
                            Text(
                              'Camera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        onTap: () {
                          _imgFromCamera();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
            foregroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          ),
          Positioned(
              bottom: 0,
              right: -21,
              child: RawMaterialButton(
                constraints: BoxConstraints.tight(Size(38, 38)),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statues =
                      await [Permission.storage, Permission.camera].request();
                  if (statues[Permission.storage]!.isGranted &&
                      statues[Permission.camera]!.isGranted) {
                    _showImagePicker(context);
                  } else {
                    print('no permission provided');
                  }
                },
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: EdgeInsets.all(6.0),
                shape: CircleBorder(),
              )),
        ],
      ),
    );
  }
}
