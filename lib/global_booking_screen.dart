// import 'package:flutter/material.dart';
// import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
// import 'package:real_estate_app/constant/constant_color.dart';
// import 'package:real_estate_app/Service/booking_service.dart';
//
// class BookingActivityScreen extends StatefulWidget {
//   const BookingActivityScreen({super.key});
//
//   @override
//   State<BookingActivityScreen> createState() => _BookingActivityScreenState();
// }
//
// class _BookingActivityScreenState extends State<BookingActivityScreen> {
//   int _currentIndex = 0;
//   bool _isLoading = true;
//   Map<String, List<Booking>> _bookingsByStatus = {
//     'Upcoming': [],
//     'Completed': [],
//     'Cancelled': [],
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBookings();
//   }
//
//   Future<void> _loadBookings() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       BookingService bookingService = BookingService();
//       Map<String, List<Booking>> bookings = await bookingService
//           .getAllBookingsByStatus();
//       setState(() {
//         _bookingsByStatus = bookings;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading bookings: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   List<Booking> get _upcomingBookings => _bookingsByStatus['Upcoming'] ?? [];
//   List<Booking> get _completedBookings => _bookingsByStatus['Completed'] ?? [];
//   List<Booking> get _cancelledBookings => _bookingsByStatus['Cancelled'] ?? [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Booking Activity',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: CustomSlidingSegmentedControl<int>(
//               initialValue: _currentIndex,
//               onValueChanged: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//               decoration: BoxDecoration(
//                 color: Color(0xFFE5E7EB),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               thumbDecoration: BoxDecoration(
//                 color: commonColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               children: {
//                 0: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 0),
//                   child: Text(
//                     'Upcoming',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 1: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     'Completed',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 2: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     'Cancelled',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               },
//               duration: Duration(milliseconds: 300),
//             ),
//           ),
//
//           // Content Area
//           Expanded(
//             child: _isLoading
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             commonColor,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text('Loading your bookings...'),
//                       ],
//                     ),
//                   )
//                 : IndexedStack(
//                     index: _currentIndex,
//                     children: [
//                       _buildBookingList(_upcomingBookings, 'Upcoming'),
//                       _buildBookingList(_completedBookings, 'Completed'),
//                       _buildBookingList(_cancelledBookings, 'Cancelled'),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookingList(List<Booking> bookings, String status) {
//     if (bookings.isEmpty) {
//       return _buildEmptyState();
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: bookings.length,
//       itemBuilder: (context, index) {
//         final booking = bookings[index];
//         return Card(
//           color: Colors.white,
//           margin: EdgeInsets.only(bottom: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           // elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: _buildImageWidget(booking.image, height: 70, width: 70),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             booking.title,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             booking.location,
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.calendar_month,
//                                 size: 16,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   booking.dateRange,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: _getStatusColor(booking.status),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 child: Text(
//                                   booking.status,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Container(
//                             child: _currentIndex == 0
//                                 ? Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: GestureDetector(
//                                               onTap: () {},
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.call,
//                                                     color: commonColor,
//                                                     size: 20,
//                                                   ),
//                                                   SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'Call Agent',
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 : _currentIndex == 1
//                                 ? Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: GestureDetector(
//                                               onTap: () {},
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.message,
//                                                     color: commonColor,
//                                                     size: 20,
//                                                   ),
//                                                   SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'Write Review',
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 15),
//                                           Expanded(
//                                             child: GestureDetector(
//                                               onTap: () {},
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.call,
//                                                     color: commonColor,
//                                                     size: 20,
//                                                   ),
//                                                   SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'Call Agent',
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 : Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: GestureDetector(
//                                               onTap: () {},
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.call,
//                                                     color: commonColor,
//                                                     size: 20,
//                                                   ),
//                                                   SizedBox(width: 10),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'Call Agent',
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Replace with your actual asset
//           Container(
//             height: 300,
//             width: 400,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/booking_error.png'),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: _currentIndex == 0
//                 ? Text(
//                     'You have no upcoming booking',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )
//                 : _currentIndex == 1
//                 ? Text(
//                     'You have no completed booking',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )
//                 : Text(
//                     'You have no cancelled booking',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               'Are you looking to book a property?',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'upcoming':
//         return Color(0xFFCFB0FA);
//       case 'completed':
//         return Color(0xFF66B185);
//       case 'cancelled':
//         return Color(0xFFFF978F);
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Widget _buildImageWidget(String imageUrl, {double? height, double? width}) {
//     if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
//       return Image.network(
//         imageUrl,
//         height: height,
//         width: width,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           // Fallback to default image if network image fails
//           return Image.asset(
//             'assets/images/Rectangle11.png',
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           );
//         },
//       );
//     } else {
//       return Image.asset(
//         imageUrl,
//         height: height,
//         width: width,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           // Fallback to default image if asset fails
//           return Image.asset(
//             'assets/images/Rectangle11.png',
//             height: height,
//             width: width,
//             fit: BoxFit.cover,
//           );
//         },
//       );
//     }
//   }
// }
//
// class Booking {
//   final String id;
//   final String title;
//   final String location;
//   final String dateRange;
//   final String price;
//   final String status;
//   final double rating;
//   final String image;
//
//   Booking({
//     required this.id,
//     required this.title,
//     required this.location,
//     required this.dateRange,
//     required this.price,
//     required this.status,
//     required this.rating,
//     required this.image,
//   });
// }

import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:real_estate_app/add_review_screen.dart';
import 'package:real_estate_app/constant/constant_color.dart';

class BookingActivityScreen extends StatefulWidget {
  const BookingActivityScreen({super.key});

  @override
  State<BookingActivityScreen> createState() => _BookingActivityScreenState();
}

class _BookingActivityScreenState extends State<BookingActivityScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  // Store bookings by status
  List<Booking> upcomingBookings = [];
  List<Booking> completedBookings = [];
  List<Booking> cancelledBookings = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (_currentUser != null) {
      _loadBookings();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      upcomingBookings = [];
      completedBookings = [];
      cancelledBookings = [];
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('userid', isEqualTo: _currentUser!.uid)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        print('DEBUG: Booking ID ${doc.id} has status: "${data['status']}"');

        DocumentSnapshot propertyDoc = await _firestore
            .collection('properties')
            .doc(data['propertyid'])
            .get();

        Map<String, dynamic>? propertyData =
            propertyDoc.data() as Map<String, dynamic>?;

        if (propertyData != null) {
          String dateRange = _formatDateRange(data);

          String rawStatus = data['status']?.toString() ?? '';
          String firebaseStatus = rawStatus
              .toLowerCase()
              .trim(); // Handle case & whitespace

          String displayStatus;
          String category;

          if (firebaseStatus == 'upcoming' ||
              firebaseStatus == 'active' ||
              firebaseStatus == 'pending' ||
              firebaseStatus == 'booked') {
            displayStatus = 'Upcoming';
            category = 'upcoming';
          } else if (firebaseStatus == 'completed' ||
              firebaseStatus == 'finished' ||
              firebaseStatus == 'done') {
            displayStatus = 'Completed';
            category = 'completed';
          } else if (firebaseStatus == 'cancelled' ||
              firebaseStatus == 'canceled' ||
              firebaseStatus == 'rejected') {
            displayStatus = 'Cancelled';
            category = 'cancelled';
          } else {
            print(
              'Unknown status: "$rawStatus" (normalized: "$firebaseStatus")',
            );
            displayStatus = 'Upcoming';
            category = 'upcoming';
          }

          Booking booking = Booking(
            id: doc.id,
            title: data['name'] ?? propertyData['name'] ?? 'Property',
            location:
                data['location'] ?? propertyData['location'] ?? 'Location',
            dateRange: dateRange,
            price:
                '\$${data['price'] ?? propertyData['price'] ?? 0}/${data['duration'] ?? propertyData['duration'] ?? 'month'}',
            status: displayStatus,
            rating: (propertyData['rating'] ?? 0).toDouble(),
            image: _getPropertyImage(propertyData),
            propertyId: data['propertyid']?.toString() ?? '',
            // agentnumber: '',
            agentnumber: propertyData['agent'][3],
          );

          if (category == 'upcoming') {
            upcomingBookings.add(booking);
          } else if (category == 'completed') {
            completedBookings.add(booking);
          } else if (category == 'cancelled') {
            cancelledBookings.add(booking);
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading bookings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateRange(Map<String, dynamic> data) {
    dynamic startTimestamp = data['startdate'];
    dynamic endTimestamp = data['enddate'];

    if (startTimestamp == null || endTimestamp == null) {
      return 'Dates not available';
    }

    DateTime? startDate;
    DateTime? endDate;

    if (startTimestamp is Timestamp) {
      startDate = startTimestamp.toDate();
    } else if (startTimestamp is String) {
      try {
        startDate = DateTime.parse(startTimestamp);
      } catch (e) {
        startDate = null;
      }
    }

    if (endTimestamp is Timestamp) {
      endDate = endTimestamp.toDate();
    } else if (endTimestamp is String) {
      try {
        endDate = DateTime.parse(endTimestamp);
      } catch (e) {
        endDate = null;
      }
    }

    if (startDate == null || endDate == null) {
      return 'Dates not available';
    }

    String start = '${startDate.day} ${_getMonthName(startDate.month)}';
    String end = '${endDate.day} ${_getMonthName(endDate.month)}';
    return '$start - $end';
  }

  String _getPropertyImage(Map<String, dynamic> propertyData) {
    if (propertyData['images'] is List &&
        (propertyData['images'] as List).isNotEmpty) {
      return (propertyData['images'][0] as String?) ??
          'assets/images/Rectangle11.png';
    }
    return 'assets/images/Rectangle11.png';
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
    return (month >= 1 && month <= 12) ? months[month - 1] : 'Month';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Booking Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: CustomSlidingSegmentedControl<int>(
              initialValue: _currentIndex,
              onValueChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              decoration: BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(10),
              ),
              thumbDecoration: BoxDecoration(
                color: commonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              children: {
                0: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                2: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              },
              duration: Duration(milliseconds: 300),
            ),
          ),

          // Content Area
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            commonColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Loading your bookings...'),
                      ],
                    ),
                  )
                : IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildBookingList(upcomingBookings, 'Upcoming'),
                      _buildBookingList(completedBookings, 'Completed'),
                      _buildBookingList(cancelledBookings, 'Cancelled'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, String status) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImageWidget(
                        booking.image,
                        height: 60,
                        width: 60,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            booking.location,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  booking.dateRange,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: _getStatusColor(booking.status),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  booking.status,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          if (_currentIndex == 1)
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddReviewScreen(propertyId:booking.propertyId,),));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.message,
                                          color: commonColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text('Write Review'),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await FlutterPhoneDirectCaller.callNumber(booking.agentnumber);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.call,
                                          color: commonColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text('Call Agent'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else if (_currentIndex == 2 || _currentIndex == 0)
                            GestureDetector(
                              onTap: () async{
                                await FlutterPhoneDirectCaller.callNumber(booking.agentnumber);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: commonColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Call Agent'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Replace with your actual asset
          Container(
            height: 300,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/booking_error.png'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: _currentIndex == 0
                ? Text(
                    'You have no upcoming booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : _currentIndex == 1
                ? Text(
                    'You have no completed booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    'You have no cancelled booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Are you looking to book a property?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Color(0xFFCFB0FA);
      case 'completed':
        return Color(0xFF66B185);
      case 'cancelled':
        return Color(0xFFFF978F);
      default:
        return Colors.grey;
    }
  }

  Widget _buildImageWidget(String imageUrl, {double? height, double? width}) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/Rectangle11.png',
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }
  }
}

class Booking {
  final String id;
  final String title;
  final String location;
  final String dateRange;
  final String price;
  final String status;
  final double rating;
  final String image;
  final String propertyId;
  final String agentnumber;
  Booking( {
    required this.propertyId,
    required this.agentnumber,
    required this.id,
    required this.title,
    required this.location,
    required this.dateRange,
    required this.price,
    required this.status,
    required this.rating,
    required this.image,
  });
}
