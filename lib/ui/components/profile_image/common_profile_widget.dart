import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/ui/components/cacher_network_images/circular_cached_network_image.dart';

class UserProfileImage extends StatelessWidget {
  final String? profileImage;
  final String? gender;
  final double size;
  final Color borderColor;
  final double radius;

  const UserProfileImage({
    super.key,
    required this.gender,
    required this.profileImage,
    this.size = 50,
    required this.borderColor,
    this.radius = 25,
  });

  @override
  Widget build(BuildContext context) {
    if (profileImage == null ||
        profileImage!.isEmpty ||
        profileImage!.trim().isEmpty) {
      return _buildDefaultProfileImage();
    } else {
      return _buildNetworkProfileImage();
    }
  }

  // Build default profile image (SVG based on gender)
  Widget _buildDefaultProfileImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: CircleAvatar(
        radius: radius,
        child: SvgPicture.asset(
          gender?.toLowerCase() == 'male'
              ? maleUserProfileSvgFilePath
              : feamleUserProfileSvgFilePath,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Build network profile image using CircularCachedNetworkImage
  Widget _buildNetworkProfileImage() {
    return CircularCachedNetworkImage(
      imageURL: '$profileImage',
      size: size,
      borderColor: borderColor,
      type: 'profile',
    );
  }
}
