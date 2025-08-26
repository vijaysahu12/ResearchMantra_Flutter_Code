import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/gender/gender_provider.dart';
import 'package:research_mantra_official/services/user_secure_storage_service.dart';
import 'package:research_mantra_official/ui/components/shimmers/home_shimmer.dart';
import 'package:research_mantra_official/ui/themes/light_theme.dart';
import 'package:shimmer/shimmer.dart';

class CircularCachedNetworkImage extends ConsumerStatefulWidget {
  final String imageURL;
  final double size;
  final Color borderColor;
  final BoxFit fit;
  final double borderWidth;
  final String? gender;
  final String? type;

  const CircularCachedNetworkImage({
    super.key,
    required this.imageURL,
    required this.size,
    required this.borderColor,
    this.fit = BoxFit.fill,
    this.borderWidth = 2,
    this.gender,
    this.type,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CircularCachedNetworkImageState();
}

class _CircularCachedNetworkImageState
    extends ConsumerState<CircularCachedNetworkImage> {
  final UserSecureStorageService _secureStorageService =
      UserSecureStorageService();
  String? selectedGender;

  @override
  void initState() {
    super.initState();

    _loadSelectedGender();
  }

  _loadSelectedGender() async {
    final String? gender = await _secureStorageService.getSelectedGender();

    // Ensure the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        selectedGender = gender;
      });
      ref.read(getGenderProvider.notifier).updateGender(gender ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    String genderValue = ref.watch(getGenderProvider).genderValue ?? "";
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.borderColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.borderWidth),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // inner circle color
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(300.0)),
              child: CachedNetworkImage(
                imageUrl: widget.imageURL,
                fit: widget.fit,
                filterQuality: FilterQuality.high,
                placeholder: (context, url) => const CircularProgressIndicator(
                  strokeWidth: 0.4,
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 30,
                  child: SvgPicture.asset(
                    height: 60,
                    widget.type!.toLowerCase() == "blog"
                        ? (widget.gender == maleGenderValue.toLowerCase()
                            ? maleUserProfileSvgFilePath
                            : feamleUserProfileSvgFilePath)
                        : (genderValue.toLowerCase() ==
                                maleGenderValue.toLowerCase()
                            ? maleUserProfileSvgFilePath
                            : feamleUserProfileSvgFilePath),
                    fit: BoxFit.fill,
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

// Widget for  blog Dashboard bottomImages
class CircularCachedNetworkDashboardBottomImages extends StatelessWidget {
  final String imageURL;

  const CircularCachedNetworkDashboardBottomImages({
    super.key,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: imageURL,
          fit: BoxFit.cover,
          placeholder: (context, url) => buildDFooterShimmers(context, theme),
          errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              dashBoardBottomSlider,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}

///Widget for single productlandscape screens
class CircularCachedNetworkLandScapeImages extends StatelessWidget {
  final String imageURL;
  final String baseUrl;
  final String defaultImagePath;
  final double aspectRatio;

  const CircularCachedNetworkLandScapeImages({
    super.key,
    required this.imageURL,
    required this.baseUrl,
    required this.defaultImagePath,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: lightTheme.shadowColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: baseUrl.toLowerCase() == 'nobase'
                  ? imageURL
                  : '$baseUrl?imageName=$imageURL',
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: theme.shadowColor,
                  highlightColor: theme.shadowColor,
                  child: Container(
                    color: theme.appBarTheme.backgroundColor,
                  ),
                );
              },
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) => Image.asset(
                defaultImagePath,
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }
}

///Widget for login screens
class CircularCachedNetworkLoginScreenImages extends StatelessWidget {
  final String imageURL;

  const CircularCachedNetworkLoginScreenImages({
    super.key,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
            imageUrl: imageURL,
            fit: BoxFit.contain,
            placeholder: (context, url) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  width: 250,
                  height: 250,
                  color: Colors.white,
                ),
              );
            },
            errorWidget: (context, url, error) => Container()));
  }
}

///Widget for  dashboard top thumbnail screens
class CircularCachedNetworkProductDashBoardThumbnailScreenImages
    extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final Decoration? decoration;

  const CircularCachedNetworkProductDashBoardThumbnailScreenImages({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.decoration,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      width: width ?? MediaQuery.of(context).size.width * 0.315,
      height: height ?? MediaQuery.of(context).size.width * 0.315,
      // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: '$getProductImageApi?imageName=$imageURL',
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width, // Adjust size as per your needs
                height: height,
                color: Colors.white,
              ),
            );
          },
          errorWidget: (context, error, stackTrace) => Image.asset(
            productDefaultmage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CircularCachedNetworkProduct extends StatelessWidget {
  final String imageURL;
  final double? width;
  final double? height;
  final Decoration? decoration;

  const CircularCachedNetworkProduct({
    super.key,
    required this.imageURL,
    this.height,
    this.width,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      width: width,
      height: width,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: '$getProductImageApi?imageName=$imageURL',
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width, // Adjust size as per your needs
                height: height,
                color: Colors.white,
              ),
            );
          },
          errorWidget: (context, error, stackTrace) => Image.asset(
            productDefaultmage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

//Cache for dahsboard services

class CircularCachedDashBoardServices extends StatelessWidget {
  final String imageURL;
  final double height;
  final double width;

  const CircularCachedDashBoardServices({
    super.key,
    required this.imageURL,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CachedNetworkImage(
        imageUrl: imageURL,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          );
        },
        errorWidget: (context, error, stackTrace) => Image.asset(
          scannerImagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

//Common Loading Builder
Widget commonLoadingBuilder(double height, double width) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width, // Adjust size as per your needs
      height: height,
      color: Colors.white,
    ),
  );
}

//Widget for image slider for blogs
class CommonImageSlider extends StatelessWidget {
  final String imageURL;

  final String defaultImagePath;
  final double aspectRatio;
  final BorderRadius borderRadius; // New parameter

  const CommonImageSlider({
    super.key,
    required this.imageURL,
    required this.defaultImagePath,
    required this.aspectRatio,
    this.borderRadius = BorderRadius.zero, // Default to no radius
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius, // Use the passed radius
        child: CachedNetworkImage(
          imageUrl: imageURL,
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: theme.shadowColor,
              highlightColor: theme.shadowColor,
              child: Container(
                color: theme.appBarTheme.backgroundColor,
              ),
            );
          },
          fit: BoxFit.cover,
          errorWidget: (context, error, stackTrace) => Image.asset(
            defaultImagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ShimmerImage extends StatelessWidget {
  final String mediaUrl;

  const ShimmerImage({super.key, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: mediaUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
    );
  }
}
