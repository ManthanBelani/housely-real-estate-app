import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant/constant_color.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final Map<int, bool?> _isLiked = {};
  List<String> name = [];
  List<double> price = [];
  List<String> duration = [];
  List<String> images = [];
  List<String> location = [];
  List<bool> isFav = [];
  List<double> rating = [];
  List<String> propertyIds = [];

  Future<void> _fetchFavPropertyData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .where('isFav', isEqualTo: true)
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

  // Map to track which items are liked
  // final Map<int, bool> _isLiked = {};
  // final List<String> name = [
  //   'Takatea Homestay',
  //   'Maharani Villa Yogyakarta',
  //   'Bali Komang Guest',
  //   'Batavia Apartments',
  //   'Manhattan Hotel ',
  // ];
  //
  // final List<double> price = [
  //   120,320,180,120,230
  // ];
  // final List<String> duration = [
  //   'night','month','night','night','night'
  // ];
  // final List<String> images = [
  //   'assets/images/Rectangle11.png',
  //   'assets/images/Rectangle11-1.png',
  //   'assets/images/Rectangle11-2.png',
  //   'assets/images/Rectangle11-3.png',
  //   'assets/images/Rectangle11-4.png',
  // ];
  @override
  void initState() {
    super.initState();
    _fetchFavPropertyData();
    for (int i = 0; i < 50; i++) {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Favorite',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body:name.isEmpty ? Center(child: Text('No Favorite Property Avialable'),) : ListView.builder(
        padding: EdgeInsets.all(5),
        // scrollDirection: Axis.vertical,
        itemCount: name.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(0),
            height: 100,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: Colors.black),
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 190,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(images[index]),
                        ),
                      ),
                    ),
                  ),
                  // child: Image.network(
                  //   images[index],
                  //   height: 200,
                  //   width: 100,
                  // ),
                ),
                Positioned(
                  left: 115,
                  top: 18,
                  child: Text(
                    name[index],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 15,
                  child: GestureDetector(
                    onTap: () => _toggleLike(index),
                    child: Icon(
                      _isLiked[index]! ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked[index]! ? Colors.red : Colors.red,
                      size: 24,
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  top: 42,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/Location.png',
                        color: Colors.grey,
                      ),
                      Text(location[index]),
                    ],
                  ),
                ),
                Positioned(
                  left: 117,
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
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFAEB),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 15, color: ratingstarcolor),
                        Text(
                          '${rating[index]}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Divider(height: 1,color: Colors.grey,)
              ],
            ),
          );
        },
      ),
    );
  }
}
