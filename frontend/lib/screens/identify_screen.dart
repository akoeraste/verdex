import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:verdex/screens/plant_library_screen.dart';
import 'package:verdex/widgets/home_header.dart';
import 'package:verdex/screens/identification_result_screen.dart';

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final List<Widget> _optionCards = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    // Start animations with a delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 + (i * 100)), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'select_language'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                _buildLanguageOption(
                  'english'.tr(),
                  '🇺🇸',
                  const Locale('en'),
                ),
                _buildLanguageOption('french'.tr(), '🇫🇷', const Locale('fr')),
              ],
            ),
          ),
    );
  }

  Widget _buildLanguageOption(String name, String flag, Locale locale) {
    final isSelected = context.locale == locale;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        context.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickAndCropImage(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'crop_image'.tr(),
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(title: 'crop_image'.tr()),
        ],
      );

      if (croppedFile != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => IdentificationResultScreen(
                  imageFile: File(croppedFile.path),
                ),
          ),
        );
      }
    } else {
      // Handle the case where the user denies the permission
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('permission_denied'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildOptionCardsList(context); // Build cards before rendering
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(
              onLanguageButtonPressed: _showLanguageSelector,
              showGreeting: false,
              showSearchBar: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'identify_page_title'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'identify_page_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    ...List.generate(_optionCards.length, (index) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _controllers[index],
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: FadeTransition(
                          opacity: _controllers[index],
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: _optionCards[index],
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildOptionCardsList(BuildContext context) {
    if (_optionCards.isNotEmpty) return;

    _optionCards.add(
      _buildOptionCard(
        context,
        icon: Icons.camera_alt,
        title: 'snap_title'.tr(),
        subtitle: 'snap_subtitle'.tr(),
        onTap: () => _pickAndCropImage(ImageSource.camera),
      ),
    );
    _optionCards.add(
      _buildOptionCard(
        context,
        icon: Icons.photo_library,
        title: 'upload_title'.tr(),
        subtitle: 'upload_subtitle'.tr(),
        onTap: () => _pickAndCropImage(ImageSource.gallery),
      ),
    );
    _optionCards.add(
      _buildOptionCard(
        context,
        icon: Icons.local_florist,
        title: 'library_title'.tr(),
        subtitle: 'library_subtitle'.tr(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlantLibraryScreen()),
          );
        },
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.green.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.green[800]),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
