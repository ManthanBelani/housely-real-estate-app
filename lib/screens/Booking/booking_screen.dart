import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/add_review_screen.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:real_estate_app/screens/Booking/add_card_screen.dart';
import 'package:real_estate_app/screens/bottom_tab_nav_screen.dart';
import 'package:real_estate_app/screens/home_screen.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';

class BookingScreen extends StatefulWidget {
  final  String propertyId;
  const BookingScreen({super.key, required this.propertyId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  User? _currentUser = FirebaseAuth.instance.currentUser;

  DateTimeRange? _selectedDateRange;
  List<DateTime> _selectedDates = [];
  CardData? _selectedCard; // Store selected card data
  String name = '';
  String location = '';
  List<String> _images = ['', '', '', ''];
  String duration = '';
  num rating = 0;
  num price = 0;
  late bool _isLoading;
  late String _error;
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPropertyFromFirebase(widget.propertyId);
    _fetchPropertyData(widget.propertyId);
  }

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

  Future<void> _saveBookingData() async {
    if (_currentUser == null) return;

    try {
      Map<String, dynamic> updateData = {
        'name' : name.trim(),
        'location' : location.trim(),
        'price' : price,
        'duration' : duration.trim(),
        'startdate' : _selectedDates.first,
        'enddate' : _selectedDates.last,
        'status' : 'Payment',
        'userid' : _currentUser?.uid,
        'propertyid' : widget.propertyId.trim(),
        'total' : price + 10,
      };

      await FirebaseFirestore.instance
          .collection('bookings').add(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Done successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error in Booking: ${e.toString()}')));
    }
  }

  String _getFormattedDateDisplay() {
    if (_selectedDates.isNotEmpty) {
      _selectedDates.sort((a, b) => a.compareTo(b));
      DateTime startDate = _selectedDates.first;
      DateTime endDate = _selectedDates.last;

      // Format as "DD MMM - DD MMM" or "DD MMM" if only one date
      if (_selectedDates.length == 1) {
        return "${startDate.day} ${_getMonthName(startDate.month)}";
      } else {
        return "${startDate.day} ${_getMonthName(startDate.month)} - ${endDate.day} ${_getMonthName(endDate.month)}";
      }
    }
    return 'Select dates';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _openDatePickerBottomSheet() {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now(),
      maximumDate: DateTime(DateTime.now().year + 1),
      primaryColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      startDate: _selectedDateRange?.start,
      endDate: _selectedDateRange?.end,
      onApplyClick: (DateTime startDate, DateTime endDate) {
        // Convert the date range to individual dates and store them
        List<DateTime> datesInRange = [];
        DateTime currentDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        while (currentDate.isBefore(endDate.add(Duration(days: 1)))) {
          datesInRange.add(
            DateTime(currentDate.year, currentDate.month, currentDate.day),
          );
          currentDate = currentDate.add(Duration(days: 1));
        }

        setState(() {
          _selectedDateRange = DateTimeRange(start: startDate, end: endDate);
          _selectedDates = datesInRange;
        });
      },
      onCancelClick: () {
        // Optionally handle cancel action
      },
    );
  }

  Future<void> _showConfirm(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF4EBFF),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/Success.png',
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        'Booking Confirmed!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'You have successfully booked the property. Get ready to enjoy your stay!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ReusableButton(
                      text: 'Explore More Properties',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomTabNavScreen(),));
                      },
                    ),
                    // SizedBox(height: 15),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     'Close',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Method to navigate to add card screen and wait for result
  Future<void> _navigateToAddCard() async {
    final result = await Navigator.push<CardData>(
      context,
      MaterialPageRoute(builder: (context) => const AddCardScreen()),
    );

    // If a card was added, update the state
    if (result != null) {
      setState(() {
        _selectedCard = result;
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
          'Booking',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddReviewScreen(propertyId: widget.propertyId,),));}, icon: Icon(Icons.add_comment))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              height: 100,
              width: 400,
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.grey),
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_images[1])),
                        ),
                        // child: Image.network(
                        //   _images[1],
                        //   height: 100,
                        //   width: 100,
                        // ),
                      ),
                    ),
                    top: -5,
                    left: -5,
                  ),
                  Positioned(
                    top: 10,
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
                    left: 105,
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
                      '\$${price}/${duration}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Positioned(
                    bottom: 7,
                    right: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color(0xFFFFFAEB),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 15, color: Color(0xFFFDB022)),
                          Text(
                            '${rating}',
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
            ), //detail container
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  'Period',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () => _openDatePickerBottomSheet(),

            child: SizedBox(
              height: 70,
              width: 350,
              child: Stack(
                children: [
                  Positioned(
                    top: 9,
                    left: 10,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.calendar_month, color: commonColor),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F5FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 13,
                    left: 80,
                    child: Text('Date', style: TextStyle(color: Colors.grey)),
                  ),
                  Positioned(
                    top: 32,
                    left: 80,
                    child: Text(
                      _getFormattedDateDisplay(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 25,
                    child: Icon(
                      size: 20,
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Make sure to check your date before making any sort of payments',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Text(
                  'Payments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          // Display selected card or add card option
          if (_selectedCard != null)
            GestureDetector(
              onTap: _navigateToAddCard, // Allow editing by tapping the card
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Row(
                  children: [
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFF9F5FF),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   // child: _getCardIconWidget(_selectedCard!.cardBrand),
                    // ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCard!.cardBrand,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _selectedCard!.maskedCardNumber,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    // Spacer(),
                    SizedBox(width: 170),
                    Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _navigateToAddCard,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.credit_card, color: commonColor),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F5FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Credit or Debit Card',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(width: 90),
                    Icon(Icons.add, color: Colors.grey),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/images/Paypal_logo.png'),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F5FF),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 20),
                Text('PayPal', style: TextStyle(fontSize: 17)),
                SizedBox(width: 200),
                Icon(Icons.add, color: Colors.grey),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(thickness: 2),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Text(
                  'Enter a Voucher',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'Price Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Period time',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  '1 Month',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly payment',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  '\$${price}',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax', style: TextStyle(fontSize: 15, color: Colors.grey)),
                Text(
                  '\$10',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${price + 10}',
                  style: TextStyle(
                    fontSize: 17,
                    color: commonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
              setState(() {
                _showConfirm(context);
                _saveBookingData();
              });
            },
            child: Text('Confirm and Pay'),
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
