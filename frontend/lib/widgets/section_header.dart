import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SectionHeader extends StatelessWidget {
  final String titleKey;
  final List<String>? args;

  const SectionHeader({super.key, required this.titleKey, this.args});

  @override
  Widget build(BuildContext context) {
    return Text(
      args == null ? titleKey.tr() : titleKey.tr(args: args!),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E7D32),
      ),
    );
  }
}
