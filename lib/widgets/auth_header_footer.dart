import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final double titleFontSize;
  final double subtitleFontSize;
  final Color? titleColor;
  final Color? subtitleColor;
  final FontWeight? titleFontWeight;
  final FontWeight? subtitleFontWeight;

  const AuthHeader({
    Key? key,
    required this.title,
    this.subtitle = 'Sign in with your email and password or social media to continue',
    this.titleFontSize = 24,
    this.subtitleFontSize = 16,
    this.titleColor,
    this.subtitleColor = Colors.grey,
    this.titleFontWeight = FontWeight.bold,
    this.subtitleFontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: subtitleColor,
            fontWeight: subtitleFontWeight,
          ),
        ),
      ],
    );
  }
}

class AuthFooter extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback? onLinkTap;
  final Color? linkColor;

  const AuthFooter({
    Key? key,
    required this.text,
    required this.linkText,
    this.onLinkTap,
    this.linkColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(width: 10),
        InkWell(
          child: Text(
            linkText,
            style: TextStyle(
              fontSize: 15,
              color: linkColor,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: onLinkTap,
        ),
      ],
    );
  }
}