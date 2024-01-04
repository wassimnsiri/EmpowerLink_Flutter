import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../env.dart';
import '../../utils/dimensions.dart';

class ApiImageLoader extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final bool isCircular;

  const ApiImageLoader({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.boxFit,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
            key: Key(imageUrl!),
            height: height,
            width: width,
            cacheKey: imageUrl,
            imageUrl: imageUrl!,
            imageBuilder: (context, imageProvider) {
              return isCircular
                  ? CircleAvatar(backgroundImage: imageProvider)
                  : Image(image: imageProvider, fit: boxFit);
            },
            progressIndicatorBuilder: (context, url, progress) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return _buildErrorWidget(
                height: height,
                width: width,
                isCircular: isCircular,
              );
            },
          )
        : _buildNoImageWidget(
            height: height,
            width: width,
            isCircular: isCircular,
          );
  }

  static Widget _buildErrorWidget({
    double? height,
    double? width,
    bool isCircular = false,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: isCircular
          ? const CircleAvatar(
              backgroundImage: AssetImage("assets/images/no-profile-pic.png"),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: Dimensions.roundedBorderMedium,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  Text(
                    "Couldn't load image",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
    );
  }

  static Widget _buildNoImageWidget({
    double? height,
    double? width,
    bool isCircular = false,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: isCircular
          ? const CircleAvatar(
              backgroundImage: AssetImage("assets/images/no-profile-pic.png"),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: Dimensions.roundedBorderMedium,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  Text(
                    "No image",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
    );
  }
}
