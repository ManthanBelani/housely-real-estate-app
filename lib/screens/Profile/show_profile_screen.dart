import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/notification_screen.dart';
import 'package:real_estate_app/screens/Auth/login_screen.dart';
import 'package:real_estate_app/screens/Profile/edit_profile_screen.dart';

import '../../Service/auth_service.dart';

class ShowProfileScreen extends StatefulWidget {
  const ShowProfileScreen({super.key});

  @override
  State<ShowProfileScreen> createState() => _ShowProfileScreenState();
}

class _ShowProfileScreenState extends State<ShowProfileScreen> {
  AuthService _authService = AuthService();

  User? _currentUser = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? _userData;
  String? userName;
  String? imageUrl;
  String? email;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;

          userName = _currentUser!.displayName ?? '';
          imageUrl = _userData?['imageURL'] ?? '';
          email = _currentUser!.email ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(
              imageUrl: imageUrl.toString(),
            ),
            SizedBox(height: 5),
            Text(
              userName.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              child: Text(
                email.toString(),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 350,
              child: Divider(height: 2, color: Colors.grey, thickness: 1.1),
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Settings",
              icon: "assets/images/Setting.png",
              press: () => {},
            ),
            ProfileMenu(
              text: "Payment",
              icon: "assets/images/Wallet.png",
              press: () {},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/images/Notification.png",
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),));
              },
            ),
            ProfileMenu(
              text: "Recently Viewed",
              icon: "assets/images/TimeSquare.png",
              press: () {},
            ),
            ProfileMenu(
              text: "About",
              icon: "assets/images/InfoSquare.png",
              press: () {},
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  _authService.signOut();
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  });
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : AssetImage('assets/images/Profile.png')),
          Positioned(
            right: -0,
            bottom: 3,
            child: SizedBox(
              height: 35,
              width: 35,
              child: TextButton(
                style: TextButton.styleFrom(
                  disabledIconColor: commonColor,
                  // foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.deepPurpleAccent),
                  ),
                  // backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: Image.asset(
                  'assets/images/Camera.png',
                  color: commonColor,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: TextButton(
        style: TextButton.styleFrom(
          // foregroundColor: const Color(0xFFFF7643),
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Image.asset(icon, width: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
