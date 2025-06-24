import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EducationalSnippet extends StatelessWidget {
  const EducationalSnippet({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF1F8E9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'did_you_know'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'tomato_fact'.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Image.asset('assets/images/tomato.png', height: 80),
            ),
          ],
        ),
      ),
    );
  }
}
