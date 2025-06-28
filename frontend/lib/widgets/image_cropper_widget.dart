import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:easy_localization/easy_localization.dart';

class ImageCropperWidget extends StatefulWidget {
  final String imagePath;
  final void Function(CroppedFile? croppedFile) onCropped;
  final VoidCallback onCancel;

  const ImageCropperWidget({
    super.key,
    required this.imagePath,
    required this.onCropped,
    required this.onCancel,
  });

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
            toolbarTitle: 'crop_image_title'.tr(),
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        if (!kIsWeb)
          IOSUiSettings(
            title: 'crop_image_title'.tr(),
            aspectRatioLockEnabled: false,
          ),
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
                              label: Text(
                                'confirm'.tr(),
                                style: const TextStyle(fontSize: 18),
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
                                _cropping ? 'cropping'.tr() : 'crop'.tr(),
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
                              label: Text(
                                'cancel'.tr(),
                                style: const TextStyle(fontSize: 18),
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
