import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';

class SampleHomeScreen extends StatefulWidget {
  const SampleHomeScreen({super.key});

  @override
  State<SampleHomeScreen> createState() => _SampleHomeScreenState();
}

class _SampleHomeScreenState extends State<SampleHomeScreen> {
  final Map<int, bool> _isLiked = {};
  final List<String> name = [
    'Takatea Homestay',
    'Maharani Villa Yogyakarta',
    'Bali Komang Guest',
    'Batavia Apartments',
    'Manhattan Hotel ',
  ];

  final List<double> price = [
    120,320,180,120,230
  ];
  final List<String> duration = [
    'night','month','night','night','night'
  ];
  final List<String> images = [
    'assets/images/Rectangle11.png',
    'assets/images/Rectangle11-1.png',
    'assets/images/Rectangle11-2.png',
    'assets/images/Rectangle11-3.png',
    'assets/images/Rectangle11-4.png',
  ];
  @override
  void initState() {
    super.initState();
    // Initialize all items as not liked by default
    // Only initialize for the actual number of items (5 in your data arrays)
    for (int i = 0; i < 5; i++) {
      _isLiked[i] = false;
    }
  }

  void _toggleLike(int index) {
    setState(() {
      _isLiked[index] = !_isLiked[index]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Location header section
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Location'),
                      Image.asset(
                        'assets/images/ArrowDown2.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 35,
                        color: commonColor,
                      ),
                      Text(
                        'Yogyakarta,Ind ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 100),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: CircleAvatar(
                          child: Image.asset('assets/images/BNotification.png'),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: CircleAvatar(
                          child: Image.asset('assets/images/Chat.png'),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Fixed search bar that stays at top during scrolling
          SliverPersistentHeader(
            pinned: true, // This keeps the header pinned at the top
            floating: false,
            delegate: SearchBarHeaderDelegate(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color:
                    Colors.white, // Ensures the background is white when pinned
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Search Property',
                    prefixIcon: Icon(
                      size: 30,
                      Icons.search,
                      color: commonColor,
                    ),
                    suffixIcon: Icon(Icons.filter_list, color: commonColor),
                  ),
                ),
              ),
            ),
          ),

          // Promo Banner
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      left: 15,
                      top: 10,
                      child: Text(
                        'GET YOUR 20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 35,
                      child: Text(
                        'CASHBACK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 80,
                      child: Text(
                        '*Expired 30 Sept',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Promo.png'),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // Recommended Section Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Recommended',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      color: commonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recommended Horizontal List
          SliverToBoxAdapter(
            child: Container(
              height: 140,

              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: name.length, // Use the length of your data arrays
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 16),
                    height: 140,
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(images[index]),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Price tag (top-right)
                        Positioned(
                          top: 10,
                          right: 6,
                          child: Container(
                            height: 20,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\$320/',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: commonColor,
                                  ),
                                ),
                                Text(duration[index], style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                        // Title (top-left)
                        Positioned(
                          left: 10,
                          bottom: 40,
                          child: Text(
                            name[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Location (bottom-left)
                        Positioned(
                          left: 5,
                          bottom: 15,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Imogiri, Yogyakarta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Like indicator (bottom-right)
                        Positioned(
                          bottom: 20,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => _toggleLike(index),
                            child: CircleAvatar(
                              maxRadius: 15,
                              backgroundColor: Colors.white,
                              child: Icon(
                                _isLiked[index]! ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked[index]! ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Nearby Section Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Nearby',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      color: commonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nearby Section with Horizontal ListView (converted from GridView to avoid nested scrolling)
          SliverToBoxAdapter(
            child: Container(
              height: 170,
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Use the actual length of your data arrays
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        width: 130, // Adjusted width to fit content better
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                name[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/Location.png',
                                    height: 16,
                                    width: 16,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Exact Location',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, top: 4),
                              child: Text(
                                '\$ ${price[index]}/${duration[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 5, bottom: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFAEB),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.yellowAccent,
                                      ),
                                      Text(
                                        '4.5',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Like button in the top-right corner
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _toggleLike(index),
                          child: Icon(
                            _isLiked[index]! ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked[index]! ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Top Locations Section Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Top Locations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      color: commonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Locations Horizontal List
          SliverToBoxAdapter(
            child: Container(
              height: 57,
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 55,
                    width: 140,
                    child: Stack(
                      children: [
                        Positioned(
                          child: Image.asset(
                            'assets/images/Rectangle11-1.png',
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Positioned(
                          left: 65,
                          top: 15,
                          child: Text(
                            'Malang',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Popular Section Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    'Popular for You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      color: commonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Popular Vertical List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              int actualIndex = index % name.length;
              return Container(
                margin: EdgeInsets.only(top: 5, right: 20, left: 20),
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(
                        images[actualIndex],
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Positioned(
                      left: 110,
                      top: 18,
                      child: Text(
                        name[actualIndex],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: () => _toggleLike(actualIndex),
                        child: Icon(
                          _isLiked[actualIndex]! ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked[actualIndex]! ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 105,
                      top: 42,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/Location.png',
                            color: Colors.grey,
                            height: 16,
                            width: 16,
                          ),
                          Text("Exact Location"),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 112,
                      bottom: 10,
                      child: Text('\$${price[actualIndex]}/${duration[actualIndex]}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 7,
                      right: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFAEB),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.yellowAccent,
                            ),
                            Text(
                              '4.5',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: 4),
          ),

          // Add some bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// Custom delegate for the persistent search bar header
class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchBarHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: child);
  }

  @override
  double get maxExtent => 74.0; // Adjusted height to match actual content

  @override
  double get minExtent => 74.0; // Same as maxExtent to keep it fixed size

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Changed to false for better performance
  }
}
