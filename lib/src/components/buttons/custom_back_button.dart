import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final double? padding;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(padding ?? 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xffF4F4F5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: iconSize ?? 20.sp,
          color: iconColor ?? Colors.black,
        ),
      ),
    );
  }
}
