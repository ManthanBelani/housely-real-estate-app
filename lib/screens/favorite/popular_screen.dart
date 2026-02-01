import 'package:flutter/material.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  // Map to track which items are liked
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
          'Popular',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(5),
        // scrollDirection: Axis.vertical,
        itemCount:name.length,
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
                  child: Image.asset(
                    images[index],
                    height: 200,
                    width: 100,
                  ),
                ),
                Positioned(
                  left: 110,
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
                  left: 105,
                  top: 42,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/Location.png',
                        color: Colors.grey,
                      ),
                      Text("Exact Location"),
                    ],
                  ),
                ),
                Positioned(left: 112, bottom: 10, child: Text('\$${price[index]}/${duration[index]}',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                        Icon(Icons.star, size: 15, color: Colors.yellowAccent),
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
                // Divider(height: 1,color: Colors.grey,)
              ],
            ),
          );
        },
      ),
    );
  }
}
