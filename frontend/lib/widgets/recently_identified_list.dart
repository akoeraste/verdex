import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'plant_card.dart';

class RecentlyIdentifiedList extends StatelessWidget {
  const RecentlyIdentifiedList({super.key});

  @override
  Widget build(BuildContext context) {
    // This would typically come from a service or state management
    final recentSearches = [
      {'name': 'apple'.tr(), 'image': 'assets/images/apple.png'},
      {'name': 'pear'.tr(), 'image': 'assets/images/pear.png'},
      {'name': 'banana'.tr(), 'image': 'assets/images/banana.png'},
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentSearches.length,
        itemBuilder: (context, index) {
          final search = recentSearches[index];
          return PlantCard(name: search['name']!, imagePath: search['image']!);
        },
      ),
    );
  }
}
