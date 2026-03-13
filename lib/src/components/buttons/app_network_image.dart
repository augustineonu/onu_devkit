import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  final Widget? placeholder;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const AppNetworkImage({
    super.key,
    this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.placeholder,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade200,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImageWidget(),
    );
  }

  Widget _buildImageWidget() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder ?? const SizedBox();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      height: height,
      width: width,
      fit: fit,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) =>
          loadingWidget ?? const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          errorWidget ?? placeholder ?? const SizedBox(),
    );
  }
}
