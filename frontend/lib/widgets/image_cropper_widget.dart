import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropperWidget extends StatefulWidget {
  final String imagePath;
  final void Function(CroppedFile? croppedFile) onCropped;
  final VoidCallback onCancel;

  const ImageCropperWidget({
    Key? key,
    required this.imagePath,
    required this.onCropped,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ImageCropperWidget> createState() => _ImageCropperWidgetState();
}

class _ImageCropperWidgetState extends State<ImageCropperWidget> {
  CroppedFile? _croppedFile;
  bool _cropping = false;

  Future<void> _cropImage() async {
    setState(() => _cropping = true);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imagePath,
      uiSettings: [
        if (!kIsWeb)
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        if (!kIsWeb)
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
        if (kIsWeb)
          WebUiSettings(context: context, presentStyle: WebPresentStyle.dialog),
      ],
    );
    setState(() {
      _cropping = false;
      _croppedFile = croppedFile;
    });
    widget.onCropped(croppedFile);
  }

  Future<void> _confirmOriginal() async {
    widget.onCropped(CroppedFile(widget.imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_croppedFile != null)
                          kIsWeb
                              ? Image.network(_croppedFile!.path)
                              : Image.file(File(_croppedFile!.path)),
                        if (_croppedFile == null)
                          kIsWeb
                              ? Image.network(widget.imagePath)
                              : Image.file(File(widget.imagePath)),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _cropping ? null : _confirmOriginal,
                              icon: const Icon(Icons.check, size: 28),
                              label: const Text(
                                'Confirm',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _cropping ? null : _cropImage,
                              icon: const Icon(Icons.crop, size: 28),
                              label: Text(
                                _cropping ? 'Cropping...' : 'Crop',
                                style: const TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _cropping ? null : widget.onCancel,
                              icon: const Icon(Icons.close, size: 28),
                              label: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
