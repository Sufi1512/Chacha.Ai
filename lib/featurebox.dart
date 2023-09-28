import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String header;
  final String Desctext;
  final double maxWidth; // Added maxWidth parameter

  const FeatureBox({
    Key? key,
    required this.color,
    required this.header,
    required this.Desctext,
    required this.maxWidth, // Added maxWidth parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ).copyWith(top: 20),
      width: maxWidth, // Set a fixed width
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Make children stretch horizontally
          children: [
            Text(
              header,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
                fontSize: 20, // Adjust font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              Desctext,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
                fontSize: 18, // Adjust font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
