import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'plant_card.dart';

class RecentlyIdentifiedList extends StatelessWidget {
  const RecentlyIdentifiedList({super.key});

  @override
  Widget build(BuildContext context) {
    // This would typically come from a service or state management
    final recentSearches = [
      {'nameKey': 'pear', 'image': 'assets/images/pear.png'},
      {'nameKey': 'banana', 'image': 'assets/images/banana.png'},
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentSearches.length,
        itemBuilder: (context, index) {
          final search = recentSearches[index];
          return PlantCard(
            name: search['nameKey']!.tr(),
            imagePath: search['image']!,
          );
        },
      ),
    );
  }
}
