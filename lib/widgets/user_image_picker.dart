import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
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
                onPressed: _pickImage,
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
