// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io' show Platform;
//
//
// class SocialShare {
//   static Future<void> shareToWhatsApp({
//     required String text,
//     String? url,
//   }) async {
//     String fullText = url != null ? '$text $url' : text;
//     String encodedText = Uri.encodeComponent(fullText);
//     String appUrl = "whatsapp://send?text=$encodedText";
//     String webUrl = "https://api.whatsapp.com/send?text=$encodedText";
//     await _launchSocialApp(appUrl: appUrl, webUrl: webUrl, appName: "WhatsApp");
//   }
//
//   static Future<void> shareToFacebook({
//     required String text,
//     String? url,
//   }) async {
//     String webUrl;
//     if (url != null) {
//       String encodedUrl = Uri.encodeComponent(url);
//       webUrl = "https://www.facebook.com/sharer/sharer.php?u=$encodedUrl";
//     } else {
//       webUrl = "https://www.facebook.com/";
//     }
//     await _launchSocialApp(appUrl: webUrl, webUrl: webUrl, appName: "Facebook");
//   }
//
//   static Future<void> shareToTwitter({
//     required String text,
//     String? url,
//     String? hashtags,
//   }) async {
//     String fullText = text;
//     if (url != null) fullText += ' $url';
//     if (hashtags != null) {
//       fullText += ' #%23${hashtags.replaceAll(',', ' #%23')}';
//     }
//     String encodedText = Uri.encodeComponent(fullText);
//     String appUrl = "twitter://post?message=$encodedText";
//     String webUrl = "https://twitter.com/intent/tweet?text=$encodedText";
//     await _launchSocialApp(appUrl: appUrl, webUrl: webUrl, appName: "Twitter");
//   }
//
//   static Future<void> openInstagram() async {
//     String appUrl = Platform.isIOS ? "instagram://app" : "instagram://mainactivity";
//     String webUrl = "https://www.instagram.com/";
//     await _launchSocialApp(appUrl: appUrl, webUrl: webUrl, appName: "Instagram");
//   }
//
//   static Future<void> shareToLinkedIn({
//     required String text,
//     String? url,
//   }) async {
//     String webUrl;
//     if (url != null) {
//       String encodedUrl = Uri.encodeComponent(url);
//       webUrl = "https://www.linkedin.com/sharing/share-offsite/?url=$encodedUrl";
//     } else {
//       webUrl = "https://www.linkedin.com/";
//     }
//     await _launchSocialApp(appUrl: webUrl, webUrl: webUrl, appName: "LinkedIn");
//   }
//
//   static Future<void> shareToPinterest({
//     required String text,
//     String? url,
//   }) async {
//     if (url == null) return;
//     String encodedUrl = Uri.encodeComponent(url);
//     String encodedDesc = Uri.encodeComponent(text);
//     String webUrl = "https://pinterest.com/pin/create/button/?url=$encodedUrl&description=$encodedDesc";
//     await _launchSocialApp(appUrl: webUrl, webUrl: webUrl, appName: "Pinterest");
//   }
//
//   static Future<void> _launchSocialApp({
//     required String appUrl,
//     required String webUrl,
//     required String appName,
//   }) async {
//     if (kIsWeb) {
//       await launchUrl(Uri.parse(webUrl));
//       return;
//     }
//
//     try {
//       if (await canLaunchUrl(Uri.parse(appUrl))) {
//         await launchUrl(Uri.parse(appUrl));
//       } else if (await canLaunchUrl(Uri.parse(webUrl))) {
//         await launchUrl(Uri.parse(webUrl));
//       } else {
//         debugPrint('Could not launch $appName');
//       }
//     } catch (e) {
//       debugPrint('Error launching $appName: $e');
//     }
//   }
// }
//
//
// Widget _buildShareButton({
//   required BuildContext context,
//   required String imagePath,
//   required String label,
//   required Color backgroundColor,
//   required VoidCallback onPressed,
// }) {
//   return Column(
//     children: [
//       Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           shape: BoxShape.circle,
//         ),
//         child: ClipOval(
//           child: Image.asset(
//             imagePath,
//             width: 32,
//             height: 32,
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//       SizedBox(height: 8),
//       Text(
//         label,
//         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         textAlign: TextAlign.center,
//       ),
//     ],
//   );
// }
