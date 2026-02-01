import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final double? borderRadius;

  const ReusableButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // fixedSize: Size(double.infinity, 70),
        // maximumSize: Size(double.infinity, 70),
        backgroundColor: backgroundColor ?? commonColor,
        foregroundColor: textColor ?? Colors.white,
        disabledBackgroundColor: commonColor,
        padding: padding ?? EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: textColor ?? Colors.white)
          : Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 18,
                color: textColor ?? Colors.white,
                fontWeight: fontWeight ?? FontWeight.w400,
              ),
            ),
    );
  }
}