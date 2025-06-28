import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LibraryPlantCard extends StatelessWidget {
  final Map<String, dynamic> plant;
  final VoidCallback? onTap;

  const LibraryPlantCard({super.key, required this.plant, this.onTap});

  String _getFallbackImageUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return 'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Plant';
    }
    return 'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=Plant';
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final translations = plant['translations'] as List<dynamic>? ?? [];
    final langCode = languageService.effectiveLanguageCode;
    final majorLang = languageService.majorLanguageCode;
    final translation = translations.firstWhere(
      (t) => t['language_code'] == langCode,
      orElse:
          () => translations.firstWhere(
            (t) => t['language_code'] == majorLang,
            orElse:
                () => translations.firstWhere(
                  (t) => t['language_code'] == 'en',
                  orElse: () => null,
                ),
          ),
    );
    final name =
        translation?['common_name'] ??
        plant['scientific_name'] ??
        'unknownPlant'.tr();
    final scientificName = plant['scientific_name'] ?? '';
    final imageUrl = plant['image_url'] ?? '';
    final family = plant['family'] ?? '';
    final category = plant['category'] ?? '';

    print('Plant card - Name: $name, Image URL: $imageUrl');

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 4,
        shadowColor: Colors.green.withAlpha((0.2 * 255).toInt()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child:
                    imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            debugPrint('Loading image: $url');
                            return Container(
                              color: const Color(0xFFF1F8E9),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF4CAF50),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            debugPrint('Image error: $url -> $error');
                            // Try fallback image
                            return CachedNetworkImage(
                              imageUrl: _getFallbackImageUrl(url),
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, fallbackUrl) => Container(
                                    color: const Color(0xFFF1F8E9),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF4CAF50),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, fallbackUrl, fallbackError) =>
                                      Container(
                                        color: const Color(0xFFF1F8E9),
                                        child: const Icon(
                                          Icons.eco,
                                          size: 40,
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                            );
                          },
                        )
                        : Container(
                          color: const Color(0xFFF1F8E9),
                          child: const Icon(
                            Icons.eco,
                            size: 40,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
              ),
            ),
            // Info section
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2E7D32),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (scientificName.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        scientificName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (family.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        family,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (category.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF4CAF50,
                          ).withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
