import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onPressed;
  final double? size;

  const SocialMediaButton({
    Key? key,
    required this.assetPath,
    this.onPressed,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: size! / 2,
        child: Image.asset(assetPath),
      ),
    );
  }
}

class SocialMediaButtonsRow extends StatelessWidget {
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onGooglePressed;
  final double spacing;

  const SocialMediaButtonsRow({
    Key? key,
    this.onFacebookPressed,
    this.onGooglePressed,
    this.spacing = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onFacebookPressed != null) 
          SocialMediaButton(
            assetPath: 'assets/images/facebook.png',
            onPressed: onFacebookPressed,
          ),
        if (onFacebookPressed != null) SizedBox(width: spacing),
        SocialMediaButton(
          assetPath: 'assets/images/google.png',
          onPressed: onGooglePressed,
        ),
      ],
    );
  }
}