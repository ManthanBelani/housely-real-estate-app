import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt2;
import 'package:url_launcher/url_launcher.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/screens/Booking/booking_screen.dart';


class SocialShare {
  static Future<void> shareToWhatsApp({required String text, String? url}) async {
    String full = url != null ? '$text $url' : text;
    String encoded = Uri.encodeComponent(full);
    String app = "whatsapp://send?text=$encoded";
    String web = "https://api.whatsapp.com/send?text=$encoded";
    await _launch(app, web);
  }

  static Future<void> shareToFacebook({required String text, String? url}) async {
    String web = url != null
        ? "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}"
        : "https://www.facebook.com/";
    await _launch(web, web);
  }

  static Future<void> shareToTwitter({required String text, String? url, String? hashtags}) async {
    String full = text;
    if (url != null) full += ' $url';
    if (hashtags != null) full += ' #%23${hashtags.replaceAll(',', ' #%23')}';
    String encoded = Uri.encodeComponent(full);
    String app = "twitter://post?message=$encoded";
    String web = "https://twitter.com/intent/tweet?text=$encoded";
    await _launch(app, web);
  }

  static Future<void> openInstagram() async {
    String app = kIsWeb ? '' : (Platform.isIOS ? "instagram://app" : "instagram://mainactivity");
    String web = "https://www.instagram.com/";
    await _launch(app, web);
  }

  static Future<void> shareToLinkedIn({required String text, String? url}) async {
    String web = url != null
        ? "https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(url)}"
        : "https://www.linkedin.com/";
    await _launch(web, web);
  }

  static Future<void> shareToPinterest({required String text, String? url}) async {
    if (url == null) return;
    String web = "https://pinterest.com/pin/create/button/?url=${Uri.encodeComponent(url)}&description=${Uri.encodeComponent(text)}";
    await _launch(web, web);
  }

  static Future<void> _launch(String appUrl, String webUrl) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(webUrl));
      return;
    }
    try {
      if (await canLaunchUrl(Uri.parse(appUrl))) {
        await launchUrl(Uri.parse(appUrl));
      } else if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(Uri.parse(webUrl));
      }
    } catch (e) {
      debugPrint("Social share error: $e");
    }
  }
}

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  String _name = '';
  String _location = '';
  num _price = 0;
  String _duration = '';
  bool _isFav = false;
  String _description = '';
  num _bedroom = 0;
  num _bathtub = 0;
  num _parking = 0;
  String _status = '';
  num _buildYear = 0;
  num _areaSqft = 0;
  List<dynamic> _agent = ['', '', '', ''];
  List<String> _images = ['', '', '', ''];
  dynamic _geolocation;
  List<String> _review1 = ['', '', ''];

  Future<Map<String, dynamic>?> getPropertyFromFirebase(String propertyId) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('properties').doc(propertyId);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting property: $e');
      return null;
    }
  }

  Future<void> _fetchPropertyData(String propertyId) async {
    try {
      Map<String, dynamic>? propertyData = await getPropertyFromFirebase(propertyId);
      if (propertyData == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Property not found')));
        return;
      }

      setState(() {
        _name = propertyData['name'] ?? '';
        _location = propertyData['location'] ?? '';
        _price = propertyData['price'] ?? 0;
        _duration = propertyData['duration'] ?? '';
        _isFav = propertyData['isFav'] ?? false;
        _description = propertyData['description'] ?? '';
        _bedroom = propertyData['bedroom'] ?? 0;
        _bathtub = propertyData['bathtub'] ?? 0;
        _parking = propertyData['parking'] ?? 0;
        _status = propertyData['Status'] ?? '';
        _buildYear = propertyData['buildYear'] ?? 0;
        _areaSqft = propertyData['areaSqft'] ?? 0;

        if (propertyData['agent'] != null && propertyData['agent'] is List) {
          List<dynamic> agentArray = List.from(propertyData['agent']);
          if (agentArray.length >= 4) {
            _agent = agentArray;
          }
        }

        if (propertyData['images'] != null && propertyData['images'] is List) {
          List<dynamic> imgList = List.from(propertyData['images']);
          _images = imgList.cast<String>();
          while (_images.length < 4) _images.add('');
        }

        if (propertyData['review1'] != null && propertyData['review1'] is List) {
          List<dynamic> reviewList = List.from(propertyData['review1']);
          _review1 = reviewList.cast<String>();
          while (_review1.length < 3) _review1.add('');
        }

        _geolocation = propertyData['geolocation'];
        print('Geolocation loaded: $_geolocation');
      });
    } catch (e) {
      print('Error fetching property data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load property: $e')));
    }
  }

  lt2.LatLng _getMapCenter() {
    if (_geolocation != null) {
      try {
        if (_geolocation.runtimeType.toString().contains('GeoPoint')) {
          final geo = _geolocation as GeoPoint;
          return lt2.LatLng(geo.latitude, geo.longitude);
        }
      } catch (e) {
        print('Error parsing geolocation: $e');
      }
    }
    return lt2.LatLng(23.026347, 72.477161);
  }

  Future<void> _showShare(BuildContext context) async {
    final String message =
        '🏡 $_name\n'
        '💰 \$${_price.toStringAsFixed(0)}/$_duration\n'
        '📍 $_location';

    final String? url = 'https://yourapp.com/property/${widget.propertyId}';

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 350,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Share to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton(
                    context: context,
                    imagePath: 'assets/images/facebook-fill.png',
                    label: 'Facebook',
                    backgroundColor: Color(0xFF537ACB),
                    onPressed: () {
                      Navigator.pop(context);
                      SocialShare.shareToFacebook(text: message, url: url);
                    },
                  ),
                  _buildShareButton(
                    context: context,
                    imagePath: 'assets/images/instagram.png',
                    label: 'Instagram',
                    backgroundColor: Colors.purpleAccent.shade100,
                    onPressed: () {
                      Navigator.pop(context);
                      SocialShare.openInstagram();
                    },
                  ),
                  _buildShareButton(
                    context: context,
                    imagePath: 'assets/images/twitter-fill.png',
                    label: 'Twitter',
                    backgroundColor: Color(0xFF13B9ED),
                    onPressed: () {
                      Navigator.pop(context);
                      SocialShare.shareToTwitter(
                        text: message,
                        url: url,
                        hashtags: "realestate,property",
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton(
                    context: context,
                    imagePath: 'assets/images/whatsapp.png',
                    label: 'WhatsApp',
                    backgroundColor: Color(0xFF25D366),
                    onPressed: () {
                      Navigator.pop(context);
                      SocialShare.shareToWhatsApp(text: message, url: url);
                    },
                  ),
                  _buildShareButton(
                    context: context,
                    imagePath: 'assets/images/linkedin-box-fill.png',
                    label: 'LinkedIn',
                    backgroundColor: Color(0xFF006599),
                    onPressed: () {
                      Navigator.pop(context);
                      SocialShare.shareToLinkedIn(text: message, url: url);
                    },
                  ),
                  _buildShareButton(
                    context: context,
                    imagePath: 'assets/images/pinterest-fill.png',
                    label: 'Pinterest',
                    backgroundColor: Color(0xFFB42318),
                    onPressed: () {
                      Navigator.pop(context);
                      SocialShare.shareToPinterest(text: message, url: url);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareButton({
    required BuildContext context,
    required String imagePath,
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              imagePath,
              width: 40,
              height: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  late MapController mapController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _fetchPropertyData(widget.propertyId);
  }

  Future<void> openDialer(String phoneNumber) async {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (phoneNumber.isEmpty) return;
    final uri = Uri.parse('tel:$phoneNumber');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your device does not support calling')),
          );
        }
      }
    } catch (e) {
      debugPrint('Dialer error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open dialer')),
        );
      }
    }
  }

  List<String> get images => _images.isNotEmpty
      ? _images
      : [
    'assets/images/Rectangle 28.png',
    'assets/images/Rectangle28-1.png',
    'assets/images/Rectangle28-2.png',
    'assets/images/Rectangle28-3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actionsPadding: EdgeInsets.all(10),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () => _showShare(context),
          ),
          IconButton(
            icon: Icon(
              _isFav == false ? Icons.favorite_border : Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _isFav = !_isFav;
                FirebaseFirestore.instance
                    .collection('properties')
                    .doc(widget.propertyId)
                    .update({'isFav': _isFav});
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _images[index].isNotEmpty
                                  ? NetworkImage(_images[index])
                                  : AssetImage(images[index]) as ImageProvider,
                            ),
                          ),
                          child: _images[index].isNotEmpty
                              ? null
                              : Center(
                            child: Icon(
                              Icons.home_outlined,
                              size: 50,
                              color: Colors.grey[300],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 300,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index ? commonColor : Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => SizedBox(width: 9),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _images[index].isNotEmpty
                              ? NetworkImage(_images[index])
                              : AssetImage(images[index]) as ImageProvider,
                        ),
                      ),
                      child: _images[index].isNotEmpty
                          ? null
                          : Center(
                        child: Icon(
                          Icons.home_outlined,
                          size: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        '\$${_price}/${_duration}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C47FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(_location, style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      _detailItem(Icons.bed, _bedroom.toString(), 'Bedrooms'),
                      _detailItem(Icons.bathtub, _bathtub.toString(), 'Bathtub'),
                      _detailItem(Icons.area_chart_outlined, '${_areaSqft.toString()} sqft', 'Area'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      _detailItem(Icons.domain, _buildYear.toString(), 'Build'),
                      _detailItem(Icons.directions_car, _parking.toString(), 'Parking'),
                      _detailItem(Icons.fiber_manual_record_outlined, _status, 'Status'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: _agent.length > 2 && _agent[2] != null
                          ? NetworkImage(_agent[2].toString())
                          : AssetImage('assets/images/Ellipse16.png') as ImageProvider,
                      radius: 25,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _agent.length > 1 ? _agent[1].toString() : 'Agent Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Real Estate Agent', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        openDialer(_agent[3]);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF9F5FF),
                          image: DecorationImage(image: AssetImage('assets/images/Call.png')),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF9F5FF),
                        image: DecorationImage(image: AssetImage('assets/images/ColoredChat.png')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location & Public Facilities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _facilityChip('Hospital', Icons.local_hospital_rounded),
                      _facilityChip('Gas stations', Icons.local_gas_station_outlined),
                      _facilityChip('Mall', Icons.shopping_bag_rounded),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 200,
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: _getMapCenter(),
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.yourapp.real_estate',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80,
                              height: 80,
                              point: _getMapCenter(),
                              child: Icon(Icons.location_on, color: commonColor, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text('See all', style: TextStyle(color: Color(0xFF6C47FF))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 120,
                    child: _review1.isNotEmpty
                        ? ListView.separated(
                      itemCount: _review1.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 120,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 10,
                                top: 10,
                                child: CircleAvatar(
                                  backgroundImage: _review1.isNotEmpty && _review1[0].isNotEmpty
                                      ? NetworkImage(_review1[0])
                                      : AssetImage('assets/images/Ellipse16.png') as ImageProvider,
                                ),
                              ),
                              Positioned(
                                left: 70,
                                top: 10,
                                child: Text(
                                  _review1.length > 1 ? _review1[1] : 'Reviewer',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Positioned(
                                left: 70,
                                bottom: 60,
                                child: Text(
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  _review1.length > 2 && _review1[2].length > 30
                                      ? _review1[2].substring(0, 30) + '...'
                                      : (_review1.length > 2 ? _review1[2] : 'No review yet'),
                                ),
                              ),
                              Positioned(
                                left: 70,
                                bottom: 40,
                                child: Text(
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  _review1.length > 2 && _review1[2].length > 60
                                      ? _review1[2].substring(30, 60)
                                      : '',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 15),
                    )
                        : ListView.separated(
                      itemCount: 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 120,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Center(
                            child: Text(
                              'No reviews yet',
                              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(propertyId: widget.propertyId)));
            },
            child: Text('Rent now'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF6C47FF),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailItem(IconData? icon, String value, String label) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                if (icon != null) Icon(icon, size: 16, color: Color(0xFF6C47FF)),
                if (icon != null) SizedBox(width: 5),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _facilityChip(String label, IconData icon) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF9F5FF),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFF6C47FF)),
          SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}