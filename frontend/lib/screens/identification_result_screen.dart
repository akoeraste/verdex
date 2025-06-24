import 'dart:io';
import 'package:flutter/material.dart';
import 'package:verdex/services/plant_service.dart';
import 'package:verdex/screens/plant_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class IdentificationResultScreen extends StatefulWidget {
  final File imageFile;

  const IdentificationResultScreen({super.key, required this.imageFile});

  @override
  State<IdentificationResultScreen> createState() =>
      _IdentificationResultScreenState();
}

class _IdentificationResultScreenState extends State<IdentificationResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Map<String, dynamic>? _result;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _identifyPlant();
  }

  Future<void> _identifyPlant() async {
    final result = await PlantService().identifyPlant(widget.imageFile);
    setState(() {
      _result = result;
      _isLoading = false;
    });
    if (result != null) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Hero(
            tag: 'plant_image', // This tag should be unique
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(widget.imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          if (!_isLoading) _buildResultContent(),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    if (_result == null) {
      return Center(
        child: Text(
          'could_not_identify_plant'.tr(),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                _result!['name'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _result!['description'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailsScreen(plant: _result!),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'view_details'.tr(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
