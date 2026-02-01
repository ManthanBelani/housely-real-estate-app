import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddReviewScreen extends StatefulWidget {
  final String propertyId;
  const AddReviewScreen({super.key, required this.propertyId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  String name = '';
  String location = '';
  List<String> _images = ['', '', '', ''];
  String duration = '';
  num rating = 0;
  num price = 0;
  late bool _isLoading;
  late String _error;

  User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>?> getPropertyFromFirebase(
    String propertyId,
  ) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId);

      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        return data;
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
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      Map<String, dynamic>? propertyData = await getPropertyFromFirebase(
        propertyId,
      );
      if (propertyData != null) {
        setState(() {
          name = propertyData['name'] ?? '';
          location = propertyData['location'] ?? '';
          price = propertyData['price'] ?? 0;
          duration = propertyData['duration'] ?? '';
          rating = propertyData['rating'] ?? 0;

          if (propertyData['images'] != null &&
              propertyData['images'] is List) {
            List<dynamic> imgList = List.from(propertyData['images']);
            _images = imgList.cast<String>();
            while (_images.length < 4) {
              _images.add('');
            }
          }
        });
      } else {}
    } catch (e) {
      setState(() {
        _error = 'Failed to load property: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveReviewData() async {
    if (_currentUser == null) return;

    try {
      Map<String, dynamic> updateData = {
        'review1': [
          _currentUser?.uid,
          _currentUser?.displayName,
          _reviewController.text.trim(),
        ],
      };

      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review Added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in adding review: ${e.toString()}')),
      );
    }
  }

  final TextEditingController _reviewController = TextEditingController();
  static const int _maxChars = 350;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchPropertyData(widget.propertyId);
    _reviewController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Write a Review',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              height: 100,
              width: 400,
              decoration: BoxDecoration(
                // border: BoxBorder.all(color: Colors.grey),
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0.0,
                    left: 5,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        image: DecorationImage(image: NetworkImage(_images[1])),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 110,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 108,
                    top: 40,
                    child: Row(
                      children: [
                        Image.asset('assets/images/Location.png'),
                        Text(
                          location,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 112,
                    bottom: 10,
                    child: Text(
                      '10 Aug - 20 Aug',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ), //detail container
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(thickness: 1, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Add Photo or Video',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(10),
                color: Colors.grey,
              ),
              child: Container(
                height: 130,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Image.asset('assets/images/Upload.png'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Write your Review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(10),
              color: Colors.grey,
            ),
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                maxLength: 350,
                controller: _reviewController,
                maxLines: 6,
                minLines: 6,
                decoration: InputDecoration(
                  hintText: 'write review about the property',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 170),
            child: Text(
              '${_maxChars - _reviewController.text.length} characters remaining',
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      persistentFooterDecoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.rectangle,
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {});
              _saveReviewData();
            },
            child: Text('Submit Review'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF6C47FF),
              textStyle: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
