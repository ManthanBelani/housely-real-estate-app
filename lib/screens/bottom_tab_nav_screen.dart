import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/filter_screen.dart';
import 'package:real_estate_app/screens/Maps/maps_screen.dart';
import 'package:real_estate_app/screens/Profile/show_profile_screen.dart';
import 'package:real_estate_app/screens/favorite/favorite_screen.dart';
import 'package:real_estate_app/screens/home_screen.dart';

import '../global_booking_screen.dart';

class BottomTabNavScreen extends StatefulWidget {
  const BottomTabNavScreen({super.key});

  @override
  State<BottomTabNavScreen> createState() => _BottomTabNavScreenState();
}

class _BottomTabNavScreenState extends State<BottomTabNavScreen> {
  int _indexSelected = 0;
  List<Widget> _pages = [
    HomeScreen(),
    FilterScreen(),
    FavoriteScreen(),
    BookingActivityScreen(),
    ShowProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_indexSelected],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        selectedItemColor: commonColor,
        currentIndex: _indexSelected,
        onTap: (value) {
          setState(() {
            _indexSelected = value;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            activeIcon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 0 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/FillHome.png',
                  color: _indexSelected == 0 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            icon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 0 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/Home.png',
                  color: _indexSelected == 0 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 1 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/Discovery.png',
                  color: _indexSelected == 1 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            icon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 1 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/Discovery.png',
                  color: _indexSelected == 1 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 2 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/FillHeart.png',
                  color: _indexSelected == 2 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            icon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 2 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/Heart.png',
                  color: _indexSelected == 2 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 3 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/FillDocument.png',
                  color: _indexSelected == 3 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            icon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 3 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/Document.png',
                  color: _indexSelected == 3 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            activeIcon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 4 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/FillProfile.png',
                  color: _indexSelected == 4 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            icon: Column(
              children: [
                Container(
                  width: 40,
                  height: 3,
                  color: _indexSelected == 4 ? commonColor : Colors.transparent,
                ),
                SizedBox(height: 15),
                Image.asset(
                  'assets/images/Profile.png',
                  color: _indexSelected == 4 ? commonColor : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}