import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/Service/location_service.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/filter_screen.dart';
import 'package:real_estate_app/notification_screen.dart';
import 'package:real_estate_app/screens/Maps/maps_screen.dart';
import 'package:real_estate_app/screens/favorite/popular_screen.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<int, bool?> _isLiked = {};
  final LocationService _locationService = LocationService();
  List<String> name = [];
  List<double> price = [];
  List<String> duration = [];
  List<String> images = [];
  List<String> location = [];
  List<bool> isFav = [];
  List<double> rating = [];
  List<String> propertyIds = [];
  List<String> topLocationNames = [];
  List<String> topLocationImages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRecommendedPropertyData();
      fetchTopLocationData();
    });
  }

  Future<void> fetchRecommendedPropertyData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .get();

      name.clear();
      price.clear();
      duration.clear();
      images.clear();
      location.clear();
      isFav.clear();
      rating.clear();
      propertyIds.clear();
      _isLiked.clear();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        name.add(data['name']?.toString() ?? 'Unnamed Property');
        price.add((data['price'] ?? 0).toDouble());
        duration.add(data['duration']?.toString() ?? 'night');

        if (data['images'] != null &&
            data['images'] is List &&
            (data['images'] as List).isNotEmpty) {
          List<dynamic> imageList = data['images'];
          images.add(
            imageList.first?.toString() ?? 'assets/images/Rectangle11.png',
          );
        } else {
          images.add('assets/images/Rectangle11.png');
        }

        location.add(data['location']?.toString() ?? 'Location not specified');
        isFav.add(data['isFav'] ?? false);
        rating.add((data['rating'] as num?)?.toDouble() ?? 4.0);
        propertyIds.add(doc.id);
      }

      for (int i = 0; i < name.length; i++) {
        _isLiked[i] = isFav[i];
      }

      if (mounted) setState(() {});
    } catch (e) {
      print('Error fetching properties: $e');
      if (mounted) setState(() {});
    }
  }

  Future<void> fetchTopLocationData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('toplocation')
          .get();

      topLocationNames.clear();
      topLocationImages.clear();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        topLocationNames.add(data['name']?.toString() ?? 'Location');
        topLocationImages.add(
          data['image']?.toString() ?? 'assets/images/Rectangle11.png',
        );
      }

      if (mounted) setState(() {});
    } catch (e) {
      print('Error fetching top locations: $e');
      topLocationNames = [];
      topLocationImages = [];
      if (mounted) setState(() {});
    }
  }

  Future<void> _toggleLike(int index) async {
    setState(() {
      _isLiked[index] = !(_isLiked[index] ?? false);
    });
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyIds[index])
        .update({'isFav': _isLiked[index]});
  }

  // Future<void> _toggleLike(int index) async {
  //   if (index < 0 || index >= propertyIds.length) {
  //     print('Invalid index: $index');
  //     return;
  //   }
  //
  //   String? propertyId = propertyIds[index];
  //   if (propertyId == null || propertyId.isEmpty) {
  //     print('Invalid property ID at index $index');
  //     return;
  //   }
  //
  //   bool newLikeValue = !(_isLiked[index] ?? false);
  //
  //   setState(() {
  //     _isLiked[index] = newLikeValue;
  //   });
  //
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('properties')
  //         .doc(propertyId)
  //         .update({'isFav': newLikeValue});
  //   } catch (e) {
  //     print('Error updating like: $e');
  //     // Revert UI on error
  //     setState(() {
  //       _isLiked[index] = !newLikeValue;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Location header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 40, left: 25, right: 20),
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
                  SizedBox(height: 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MapsScreen(),));
                        },
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 35,
                          color: commonColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _locationService.getLocationAndSaveToFirebase();
                          });
                        },
                        child: Text(
                          _locationService.locationMessage ?? 'No Location',
                          style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),));
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Image.asset('assets/images/BNotification.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.asset('assets/images/Chat.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchBarHeaderDelegate(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen(),));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.white,
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search Property',
                      prefixIcon: Icon(Icons.search, color: commonColor),
                      suffixIcon: Icon(Icons.filter_list, color: commonColor),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Promo Banner
          SliverToBoxAdapter(
            child: CarouselSlider.builder(
              itemCount: 4,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Promo.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GET YOUR 20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'CASHBACK',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '*Expired 30 Sept',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 120,
                aspectRatio: 2 / 3,
                autoPlay: true,
              ),
            ),
          ),

          // Recommended Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
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
          SliverToBoxAdapter(
            child: name.isEmpty
                ? SkeletonLoader(
                    builder: Container(height: 140, width: 220),
                    items: 2,
                    highlightColor: Colors.yellow.shade100,
                    direction: SkeletonDirection.ttb,
                  )
                : Container(
                    height: 140,
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: name.length,
                      itemBuilder: (context, index) {
                        final isLiked = _isLiked[index] ?? false;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailScreen(
                                  propertyId: propertyIds[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: images[index].startsWith('http')
                                    ? NetworkImage(images[index])
                                    : AssetImage(images[index])
                                          as ImageProvider,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 6,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '\$${price[index]}/',
                                          style: TextStyle(
                                            color: commonColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          duration[index],
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                                        location[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () => _toggleLike(index),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),

          // Nearby Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
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
          SliverToBoxAdapter(
            child: Container(
              height: 170,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: name.length,
                itemBuilder: (context, index) {
                  final isLiked = _isLiked[index] ?? false;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailScreen(
                            propertyId: propertyIds[index],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: images[index].startsWith('http')
                                      ? NetworkImage(images[index])
                                      : AssetImage(images[index])
                                            as ImageProvider,
                                  height: 60,
                                  width: double.infinity,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                      location[index],
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8, top: 4),
                                child: Text(
                                  '\$${price[index]}/${duration[index]}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 5, bottom: 5),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
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
                                        color: ratingstarcolor,
                                      ),
                                      Text(
                                        ' ${rating[index].toStringAsFixed(1)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => _toggleLike(index),
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 20,
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

          // Top Locations
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
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
          SliverToBoxAdapter(
            child: Container(
              height: 57,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topLocationNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 12),
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: topLocationImages[index].startsWith('http')
                                ? NetworkImage(topLocationImages[index])
                                : AssetImage(topLocationImages[index])
                                      as ImageProvider,
                            height: 55,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          topLocationNames[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Popular for You
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    'Popular for You',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PopularScreen(),));
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 12,
                        color: commonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final isLiked = _isLiked[index] ?? false;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PropertyDetailScreen(propertyId: propertyIds[index]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: images[index].startsWith('http')
                              ? NetworkImage(images[index])
                              : AssetImage(images[index]) as ImageProvider,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/images/Rectangle11.png',
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      Positioned(
                        left: 110,
                        top: 18,
                        child: Text(
                          name[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: () => _toggleLike(index),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
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
                              height: 16,
                              width: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Exact Location",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 112,
                        bottom: 10,
                        child: Text(
                          '\$${price[index]}/${duration[index]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 7,
                        right: 15,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFAEB),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 15,
                                color: ratingstarcolor,
                              ),
                              Text(
                                ' ${rating[index].toStringAsFixed(1)}',
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
                ),
              );
            }, childCount: name.length),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchBarHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 74.0;

  @override
  double get minExtent => 74.0;

  @override
  bool shouldRebuild(covariant SearchBarHeaderDelegate oldDelegate) => false;
}
