import 'package:flutter/material.dart';
import 'package:research_mantra_official/constants/assets.dart';

class CommonLoaderGif extends StatelessWidget {
  const CommonLoaderGif({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(appLoderGif),
    );
  }
}
