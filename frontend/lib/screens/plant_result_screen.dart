import 'package:flutter/material.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:verdex/services/plant_classifier_service.dart';

class PlantResultScreen extends StatefulWidget {
  final File imageFile;

  const PlantResultScreen({super.key, required this.imageFile});

  @override
  State<PlantResultScreen> createState() => _PlantResultScreenState();
}

class _PlantResultScreenState extends State<PlantResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Plant classifier service
  final PlantClassifierService _classifierService = PlantClassifierService();

  // Prediction state
  bool _isPredicting = false;
  Map<String, dynamic>? _predictionResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _startAnimations();
    _runPrediction();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  /// Run plant classification prediction
  Future<void> _runPrediction() async {
    setState(() {
      _isPredicting = true;
      _errorMessage = null;
    });

    try {
      final result = await _classifierService.predict(widget.imageFile);
      setState(() {
        _predictionResult = result;
        _isPredicting = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isPredicting = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _classifierService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Sticky Header
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(context).pop(),
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'identification_result'.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image container
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF000000,
                                  ).withOpacity(0.1),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                widget.imageFile,
                                height: 240,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Plant Classification Result
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF000000,
                                ).withOpacity(0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (_isPredicting) ...[
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF667EEA),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'analyzing_image'.tr(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF667EEA),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'running_plant_classification'.tr(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ] else if (_predictionResult != null) ...[
                                // Success State
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFF45A049),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF4CAF50,
                                        ).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.eco,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getPlantName(
                                    _predictionResult!['predictedIndex'],
                                  ),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // View Details Button
                                ElevatedButton(
                                  onPressed: () {
                                    final plantName = _getPlantName(
                                      _predictionResult!['predictedIndex'],
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      '/plant-details/${plantName.toLowerCase()}',
                                    );
                                  },
                                  child: Text('View Details'),
                                ),
                                const SizedBox(height: 16),
                                // Confidence Display
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'confidence'.tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Text(
                                      '  ${_predictionResult!['confidencePercentage']}%',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: _predictionResult!['confidence'],
                                  backgroundColor: const Color(0xFFE0E0E0),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Additional Info
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF4CAF50,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: const Color(0xFF4CAF50),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'plant_detected_message'.tr(
                                            args: [
                                              _getPlantName(
                                                _predictionResult!['predictedIndex'],
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color(0xFF2E7D32),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Identify another plant button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                },
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Color(0xFF666666),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'identify_another_plant',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom padding for navbar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPlantName(int index) {
    // Replace with actual plant names in the order of your model's output
    const plantNames = [
      'Tomato',
      'Mango',
      'Banana',
      'Apple',
      'Pear',
      'Orange',
      'Grape',
      'Pineapple',
      'Strawberry',
      'Watermelon',
      'Lemon',
      'Peach',
      'Plum',
      'Cherry',
      'Avocado',
      'Coconut',
      'Papaya',
      'Guava',
      'Kiwi',
      'Blueberry',
      'Raspberry',
      'Blackberry',
      'Fig',
      'Pomegranate',
      'Lychee',
      'Jackfruit',
      'Passionfruit',
      'Dragonfruit',
      'Date',
      'Olive',
    ];
    if (index >= 0 && index < plantNames.length) {
      return plantNames[index];
    }
    return 'Unknown Plant';
  }
}
