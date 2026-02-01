// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'constant/constant_color.dart';
//
// class FilterScreen extends StatefulWidget {
//   const FilterScreen({super.key});
//
//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }
//
// class _FilterScreenState extends State<FilterScreen> {
//   final TextEditingController _textController = TextEditingController();
//
//   List<Map<String, dynamic>> _allProperties = [];
//   List<Map<String, dynamic>> _filteredProperties = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProperties();
//   }
//
//   bool forRent = true;
//   bool forSale = false;
//   bool apartment = true;
//   bool penthouse = false;
//   bool hotel = true;
//   bool villa = false;
//
//   double minPrice = 10.0;
//   double maxPrice = 800.0;
//
//   bool hasBedroom = false;
//   bool hasBathtub = false;
//   bool hasAC = true;
//   bool hasWiFi = false;
//
//   Future<void> _loadProperties() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('properties')
//           .get();
//
//       List<Map<String, dynamic>> properties = [];
//       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         data['id'] = doc.id;
//         properties.add(data);
//       }
//
//       properties.sort((a, b) {
//         String nameA = (a['name'] as String?)?.toLowerCase() ?? '';
//         String nameB = (b['name'] as String?)?.toLowerCase() ?? '';
//         return nameA.compareTo(nameB);
//       });
//
//       setState(() {
//         _allProperties = properties;
//         _filteredProperties = properties;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading properties: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   // void _filterPropertiesByLocation(String searchText) {
//   //   if (searchText.isEmpty) {
//   //     setState(() {
//   //       _filteredProperties = _allProperties;
//   //     });
//   //     return;
//   //   }
//   //
//   //   final searchLower = searchText.toLowerCase();
//   //
//   //   setState(() {
//   //     _filteredProperties = _allProperties.where((property) {
//   //       String location =
//   //           (property['location'] as String?)?.toLowerCase() ?? '';
//   //       String name = (property['name'] as String?)?.toLowerCase() ?? '';
//   //       return location.contains(searchLower) || name.contains(searchLower);
//   //     }).toList();
//   //   });
//   // }
//
//   // Keep track of the current search text
//   String _currentSearchText = '';
//
//   void _applyFilters() {
//     List<Map<String, dynamic>> filtered = _allProperties;
//
//     // Filter by For Rent / For Sale using the 'status' field
//     if (forRent || forSale) {
//       filtered = filtered.where((property) {
//         String status = (property['status']?.toString() ?? '');
//
//         bool matchesRent = false;
//         bool matchesSale = false;
//
//         if (forRent) {
//           matchesRent = status.contains('For Rent');
//         }
//
//         if (forSale) {
//           matchesSale = status.contains('sale') || status.contains('For Sell');
//         }
//
//         // If both are selected, show properties that match either
//         if (forRent && forSale) {
//           return matchesRent || matchesSale;
//         }
//         // If only forRent is selected
//         else if (forRent) {
//           return matchesRent;
//         }
//         // If only forSale is selected
//         else {
//           return matchesSale;
//         }
//       }).toList();
//     }
//
//     // Filter by Property Type
//     List<String> selectedTypes = [];
//     if (apartment) selectedTypes.add('apartment');
//     if (penthouse) selectedTypes.add('penthouse');
//     if (hotel) selectedTypes.add('hotel');
//     if (villa) selectedTypes.add('villa');
//
//     // Only filter by type if not all are selected
//     if (selectedTypes.isNotEmpty && selectedTypes.length < 4) {
//       filtered = filtered.where((property) {
//         String type = (property['type']?.toString() ?? '').toLowerCase();
//         String propertyType = (property['property_type']?.toString() ?? '').toLowerCase();
//         String combinedType = '$type $propertyType';
//
//         return selectedTypes.any((selectedType) => combinedType.contains(selectedType));
//       }).toList();
//     }
//
//     // Filter by Price Range
//     filtered = filtered.where((property) {
//       dynamic priceValue = property['price'];
//
//       if (priceValue is String) {
//         priceValue = double.tryParse(
//           priceValue.replaceAll('\$', '').replaceAll(',', '').trim(),
//         );
//       } else if (priceValue is int) {
//         priceValue = priceValue.toDouble();
//       }
//
//       if (priceValue is double) {
//         return priceValue >= minPrice && priceValue <= maxPrice;
//       }
//       return true;
//     }).toList();
//
//     // Apply search on top of filtered results if there's a search term
//     if (_currentSearchText.isNotEmpty) {
//       final searchLower = _currentSearchText.toLowerCase();
//       filtered = filtered.where((property) {
//         String location = (property['location'] as String?)?.toLowerCase() ?? '';
//         String name = (property['name'] as String?)?.toLowerCase() ?? '';
//         return location.contains(searchLower) || name.contains(searchLower);
//       }).toList();
//     }
//
//     setState(() {
//       _filteredProperties = filtered;
//     });
//   }
//
//   void _filterPropertiesByLocation(String searchText) {
//     _currentSearchText = searchText;
//     _applyFilters(); // Always use _applyFilters which considers all filters + search
//   }
//
// // Also add this variable at the top of your _FilterScreenState class:
// // String _currentSearchText = '';
//
//   // void _filterPropertiesByLocation(String searchText) {
//   //   // First apply all filters
//   //   _applyFilters();
//   //
//   //   // Then apply search on top of filtered results
//   //   if (searchText.isEmpty) {
//   //     return;
//   //   }
//   //
//   //   final searchLower = searchText.toLowerCase();
//   //
//   //   setState(() {
//   //     _filteredProperties = _filteredProperties.where((property) {
//   //       String location = (property['location'] as String?)?.toLowerCase() ?? '';
//   //       String name = (property['name'] as String?)?.toLowerCase() ?? '';
//   //       return location.contains(searchLower) || name.contains(searchLower);
//   //     }).toList();
//   //   });
//   // }
//
//   Future<void> _showFilter(BuildContext context) async {
//     await showModalBottomSheet(
//       constraints: BoxConstraints(minWidth: 400, maxWidth: 400, minHeight: 800),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       context: context,
//       builder: (context) {
//
//         bool localForRent = forRent;
//         bool localForSale = forSale;
//         bool localApartment = apartment;
//         bool localPenthouse = penthouse;
//         bool localHotel = hotel;
//         bool localVilla = villa;
//         double localMinPrice = minPrice;
//         double localMaxPrice = maxPrice;
//         bool localHasBedroom = hasBedroom;
//         bool localHasBathtub = hasBathtub;
//         bool localHasAC = hasAC;
//         bool localHasWiFi = hasWiFi;
//
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Filter",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//
//                     Text(
//                       'Looking for',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('For Rent'),
//                         Checkbox(
//                           value: localForRent,
//                           onChanged: (value) {
//                             setModalState(() => localForRent = value!);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: commonColor,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('For Sale'),
//                         Checkbox(
//                           value: localForSale,
//                           onChanged: (value) {
//                             setModalState(() => localForSale = value!);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: commonColor,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//
//                     Text(
//                       'Property Type',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Apartment'),
//                         Checkbox(
//                           value: localApartment,
//                           onChanged: (value) {
//                             setModalState(() => localApartment = value!);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: commonColor,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Penthouse'),
//                         Checkbox(
//                           value: localPenthouse,
//                           onChanged: (value) {
//                             setModalState(() => localPenthouse = value!);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: commonColor,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Hotel'),
//                         Checkbox(
//                           value: localHotel,
//                           onChanged: (value) {
//                             setModalState(() => localHotel = value!);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: commonColor,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Villa'),
//                         Checkbox(
//                           value: localVilla,
//                           onChanged: (value) {
//                             setModalState(() => localVilla = value!);
//                           },
//                           checkColor: Colors.white,
//                           activeColor: commonColor,
//                         ),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setModalState(() {
//                           localApartment = true;
//                           localPenthouse = true;
//                           localHotel = true;
//                           localVilla = true;
//                         });
//                       },
//                       child: Text(
//                         'Show all',
//                         style: TextStyle(
//                           color: commonColor,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Price Range',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     RangeSlider(
//                       values: RangeValues(localMinPrice, localMaxPrice),
//                       min: 10,
//                       max: 800,
//                       divisions: 790,
//                       labels: RangeLabels(
//                         '\$${localMinPrice.toInt()}',
//                         '\$${localMaxPrice.toInt()}',
//                       ),
//                       activeColor: commonColor,
//                       inactiveColor: Colors.grey[300],
//                       onChanged: (RangeValues values) {
//                         setModalState(() {
//                           localMinPrice = values.start;
//                           localMaxPrice = values.end;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       'Facilities',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setModalState(() => localHasBedroom = !localHasBedroom);
//                           },
//                           child: Container(
//                             width: 80,
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: commonColor),
//                               borderRadius: BorderRadius.circular(12),
//                               color: localHasBedroom ? commonColor.withOpacity(0.15) : Colors.white,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.bed_outlined,
//                                   color: localHasBedroom ? commonColor : Colors.grey[600],
//                                   size: 20,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Bed room',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: localHasBedroom ? commonColor : Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setModalState(() => localHasBathtub = !localHasBathtub);
//                           },
//                           child: Container(
//                             width: 80,
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: commonColor),
//                               borderRadius: BorderRadius.circular(12),
//                               color: localHasBathtub ? commonColor.withOpacity(0.15) : Colors.white,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.bathtub_outlined,
//                                   color: localHasBathtub ? commonColor : Colors.grey[600],
//                                   size: 20,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Bathtub',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: localHasBathtub ? commonColor : Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setModalState(() => localHasAC = !localHasAC);
//                           },
//                           child: Container(
//                             width: 80,
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: commonColor),
//                               borderRadius: BorderRadius.circular(12),
//                               color: localHasAC ? commonColor.withOpacity(0.15) : Colors.white,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.ac_unit_outlined,
//                                   color: localHasAC ? commonColor : Colors.grey[600],
//                                   size: 20,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'AC',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: localHasAC ? commonColor : Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setModalState(() => localHasWiFi = !localHasWiFi);
//                           },
//                           child: Container(
//                             width: 80,
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: commonColor),
//                               borderRadius: BorderRadius.circular(12),
//                               color: localHasWiFi ? commonColor.withOpacity(0.15) : Colors.white,
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.wifi_outlined,
//                                   color: localHasWiFi ? commonColor : Colors.grey[600],
//                                   size: 20,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'WiFi',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: localHasWiFi ? commonColor : Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 40),
//
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setModalState(() {
//                                 localForRent = true;
//                                 localForSale = false;
//                                 localApartment = true;
//                                 localPenthouse = false;
//                                 localHotel = true;
//                                 localVilla = false;
//                                 localMinPrice = 10;
//                                 localMaxPrice = 800;
//                                 localHasBedroom = false;
//                                 localHasBathtub = false;
//                                 localHasAC = false;
//                                 localHasWiFi = false;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white70,
//                               padding: EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               'Reset',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               forRent = localForRent;
//                               forSale = localForSale;
//                               apartment = localApartment;
//                               penthouse = localPenthouse;
//                               hotel = localHotel;
//                               villa = localVilla;
//                               minPrice = localMinPrice;
//                               maxPrice = localMaxPrice;
//                               hasBedroom = localHasBedroom;
//                               hasBathtub = localHasBathtub;
//                               hasAC = localHasAC;
//                               hasWiFi = localHasWiFi;
//
//                               Navigator.pop(context);
//
//                               setState(() {
//                                 _applyFilters();
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: commonColor,
//                               padding: EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               'Apply',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildFacilityChip({
//     required IconData icon,
//     required String label,
//     required bool isSelected,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 80,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: commonColor),
//         borderRadius: BorderRadius.circular(12),
//         color: isSelected ? commonColor.withOpacity(0.15) : Colors.white,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? commonColor : Colors.grey[600],
//             size: 20,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: isSelected ? commonColor : Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 40),
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               color: Colors.white,
//               child: TextFormField(
//                 controller: _textController,
//                 enabled: true,
//                 style: TextStyle(),
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   hintText: 'Search Property',
//                   prefixIcon: Icon(size: 30, Icons.search, color: commonColor),
//                   suffixIcon: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showFilter(context);
//                       });
//                     },
//                     child: Icon(Icons.filter_list, color: commonColor),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   _filterPropertiesByLocation(value);
//                 },
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 25, top: 10),
//                 child: Text(
//                   "Result",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           _isLoading
//               ? Expanded(
//                   child: Center(
//                     child: CircularProgressIndicator(color: commonColor),
//                   ),
//                 )
//               : Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredProperties.length,
//                     itemBuilder: (context, index) {
//                       final property = _filteredProperties[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: ListTile(
//                           leading: Icon(Icons.location_on_outlined),
//                           title: Text(
//                             property['name'] ?? 'Property Name',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(
//                             property['location'] ?? 'Location Unknown',
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/screens/details_screen.dart';
import 'constant/constant_color.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _textController = TextEditingController();

  List<Map<String, dynamic>> _allProperties = [];
  List<Map<String, dynamic>> _filteredProperties = [];
  bool _isLoading = true;
  String _currentSearchText = '';

  // Filter variables
  bool forRent = false;
  bool forSale = false;
  bool apartment = true;
  bool penthouse = true;
  bool hotel = true;
  bool villa = true;
  double minPrice = 10.0;
  double maxPrice = 800.0;
  bool hasBedroom = false;
  bool hasBathtub = false;
  bool hasAC = false;
  bool hasWiFi = false;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .get();

      List<Map<String, dynamic>> properties = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        properties.add(data);
      }

      properties.sort((a, b) {
        String nameA = (a['name'] as String?)?.toLowerCase() ?? '';
        String nameB = (b['name'] as String?)?.toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      });

      setState(() {
        _allProperties = properties;
        _filteredProperties = properties;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading properties: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    print('\n========== APPLYING FILTERS ==========');
    print('forRent: $forRent');
    print('forSale: $forSale');
    print('Total properties before filter: ${_allProperties.length}');

    List<Map<String, dynamic>> filtered = List.from(_allProperties);

    if (forRent || forSale) {
      print('Applying status filter...');
      filtered = filtered.where((property) {
        String status = property['Status']?.toString() ?? '';

        if (forRent && !forSale) {
          bool matches = status == 'For Rent';
          print(
            '  ${property['name']}: Status="$status" -> matches ForRent: $matches',
          );
          return matches;
        } else if (!forRent && forSale) {
          bool matches = status == 'For Sell' || status == 'For Sale';
          print(
            '  ${property['name']}: Status="$status" -> matches ForSale: $matches',
          );
          return matches;
        } else {
          bool matches =
              status == 'For Rent' ||
              status == 'For Sell' ||
              status == 'For Sale';
          print(
            '  ${property['name']}: Status="$status" -> matches Both: $matches',
          );
          return matches;
        }
      }).toList();
      print('After status filter: ${filtered.length} properties');
    } else {
      print('No status filter (both unchecked) - showing all');
    }

    List<String> selectedTypes = [];
    if (apartment) selectedTypes.add('apartment');
    if (penthouse) selectedTypes.add('penthouse');
    if (hotel) selectedTypes.add('hotel');
    if (villa) selectedTypes.add('villa');

    if (selectedTypes.length > 0 && selectedTypes.length < 4) {
      print('Applying type filter: $selectedTypes');
      filtered = filtered.where((property) {
        String type = (property['type']?.toString() ?? '').toLowerCase();
        String propertyType = (property['property_type']?.toString() ?? '')
            .toLowerCase();
        String combinedType = '$type $propertyType';
        return selectedTypes.any(
          (selectedType) => combinedType.contains(selectedType),
        );
      }).toList();
      print('After type filter: ${filtered.length} properties');
    }

    print(
      'Applying price filter: \$${minPrice.toInt()} - \$${maxPrice.toInt()}',
    );
    filtered = filtered.where((property) {
      dynamic priceValue = property['price'];

      if (priceValue is String) {
        priceValue = double.tryParse(
          priceValue.replaceAll('\$', '').replaceAll(',', '').trim(),
        );
      } else if (priceValue is int) {
        priceValue = priceValue.toDouble();
      }

      if (priceValue is double) {
        return priceValue >= minPrice && priceValue <= maxPrice;
      }
      return true;
    }).toList();
    print('After price filter: ${filtered.length} properties');

    if (_currentSearchText.isNotEmpty) {
      print('Applying search filter: "$_currentSearchText"');
      final searchLower = _currentSearchText.toLowerCase();
      filtered = filtered.where((property) {
        String location =
            (property['location'] as String?)?.toLowerCase() ?? '';
        String name = (property['name'] as String?)?.toLowerCase() ?? '';
        return location.contains(searchLower) || name.contains(searchLower);
      }).toList();
      print('After search filter: ${filtered.length} properties');
    }

    print('FINAL RESULT: ${filtered.length} properties');
    print('======================================\n');

    setState(() {
      _filteredProperties = filtered;
    });
  }

  void _filterPropertiesByLocation(String searchText) {
    _currentSearchText = searchText;
    _applyFilters();
  }

  Future<void> _showFilter(BuildContext context) async {
    await showModalBottomSheet(
      constraints: BoxConstraints(minWidth: 400, maxWidth: 400, minHeight: 800),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        bool localForRent = forRent;
        bool localForSale = forSale;
        bool localApartment = apartment;
        bool localPenthouse = penthouse;
        bool localHotel = hotel;
        bool localVilla = villa;
        double localMinPrice = minPrice;
        double localMaxPrice = maxPrice;
        bool localHasBedroom = hasBedroom;
        bool localHasBathtub = hasBathtub;
        bool localHasAC = hasAC;
        bool localHasWiFi = hasWiFi;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Looking for',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('For Rent'),
                        Checkbox(
                          value: localForRent,
                          onChanged: (value) {
                            setModalState(() => localForRent = value!);
                          },
                          checkColor: Colors.white,
                          activeColor: commonColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('For Sale'),
                        Checkbox(
                          value: localForSale,
                          onChanged: (value) {
                            setModalState(() => localForSale = value!);
                          },
                          checkColor: Colors.white,
                          activeColor: commonColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Property Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Apartment'),
                        Checkbox(
                          value: localApartment,
                          onChanged: (value) {
                            setModalState(() => localApartment = value!);
                          },
                          checkColor: Colors.white,
                          activeColor: commonColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Penthouse'),
                        Checkbox(
                          value: localPenthouse,
                          onChanged: (value) {
                            setModalState(() => localPenthouse = value!);
                          },
                          checkColor: Colors.white,
                          activeColor: commonColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hotel'),
                        Checkbox(
                          value: localHotel,
                          onChanged: (value) {
                            setModalState(() => localHotel = value!);
                          },
                          checkColor: Colors.white,
                          activeColor: commonColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Villa'),
                        Checkbox(
                          value: localVilla,
                          onChanged: (value) {
                            setModalState(() => localVilla = value!);
                          },
                          checkColor: Colors.white,
                          activeColor: commonColor,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          localApartment = true;
                          localPenthouse = true;
                          localHotel = true;
                          localVilla = true;
                        });
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(
                          color: commonColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    RangeSlider(
                      values: RangeValues(localMinPrice, localMaxPrice),
                      min: 10,
                      max: 1000,
                      divisions: 990,
                      labels: RangeLabels(
                        '\$${localMinPrice.toInt()}',
                        '\$${localMaxPrice.toInt()}',
                      ),
                      activeColor: commonColor,
                      inactiveColor: Colors.grey[300],
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          localMinPrice = values.start;
                          localMaxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                localForRent = false;
                                localForSale = false;
                                localApartment = true;
                                localPenthouse = true;
                                localHotel = true;
                                localVilla = true;
                                localMinPrice = 10;
                                localMaxPrice = 800;
                                localHasBedroom = false;
                                localHasBathtub = false;
                                localHasAC = false;
                                localHasWiFi = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white70,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print('\n***** APPLY BUTTON CLICKED *****');
                              print(
                                'Local values: forRent=$localForRent, forSale=$localForSale',
                              );

                              Navigator.pop(context);

                              setState(() {
                                forRent = localForRent;
                                forSale = localForSale;
                                apartment = localApartment;
                                penthouse = localPenthouse;
                                hotel = localHotel;
                                villa = localVilla;
                                minPrice = localMinPrice;
                                maxPrice = localMaxPrice;
                                hasBedroom = localHasBedroom;
                                hasBathtub = localHasBathtub;
                                hasAC = localHasAC;
                                hasWiFi = localHasWiFi;
                              });

                              print(
                                'Parent values updated: forRent=$forRent, forSale=$forSale',
                              );
                              _applyFilters();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: commonColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.white,
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Search Property',
                  prefixIcon: Icon(size: 30, Icons.search, color: commonColor),
                  suffixIcon: GestureDetector(
                    onTap: () => _showFilter(context),
                    child: Icon(Icons.filter_list, color: commonColor),
                  ),
                ),
                onChanged: (value) => _filterPropertiesByLocation(value),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
            child: Row(
              children: [
                Text(
                  "Results: ${_filteredProperties.length}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: commonColor),
                  ),
                )
              : _filteredProperties.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'No properties found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Try a different keyword or adjust filters'),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _filteredProperties.length,
                    itemBuilder: (context, index) {
                      final property = _filteredProperties[index];
                      return Container(
                        height: 70,
                        decoration: BoxDecoration(
                          // border: BoxBorder.all(color: Colors.black)
                        ),
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Positioned(
                                top: 17,
                                left: 15,
                                child: Icon(Icons.location_on_outlined,size: 30,)),
                            Positioned(
                              left: 60,
                              top: 10,
                              child: Text(
                                property['name'] ?? 'Property Name',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
                              ),
                            ),
                            Positioned(
                              left: 60,
                              top: 35,
                              child: Text(
                                '${property['location'] ?? ''} • ${property['Status'] ?? ''}',
                              ),
                            ),
                          ],
                        ),
                      );
                      // return ListTile(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => PropertyDetailScreen(propertyId: property['id']),
                      //       ),
                      //     );
                      //   },
                      //   isThreeLine: true,
                      //   // contentPadding: EdgeInsets.only(left: 10,top: 0),
                      //   leading: CircleAvatar(
                      //     child: Icon(Icons.location_on_outlined),
                      //   ),
                      //   title: Text(
                      //     property['name'] ?? 'Property Name',
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      //   subtitle: Text(
                      //     '${property['location'] ?? ''} • ${property['Status'] ?? ''}',
                      //   ),
                      // );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
