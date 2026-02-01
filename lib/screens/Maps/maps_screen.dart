// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:real_estate_app/widgets/reusable_button.dart';
// import 'package:real_estate_app/widgets/reusable_text_field.dart';
//
// class MapsScreen extends StatefulWidget {
//   const MapsScreen({super.key});
//
//   @override
//   State<MapsScreen> createState() => _MapsScreenState();
// }
//
// class _MapsScreenState extends State<MapsScreen> {
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   late GoogleMapController mapController;
//   final LatLng _center = const LatLng(23.026347, 72.477161);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Google Map as background
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _center,
//               zoom: 14.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: const MarkerId('selected_location'),
//                 position: _center,
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
//                 infoWindow: const InfoWindow(title: 'Selected Location'),
//               ),
//             },
//             mapType: MapType.normal,
//             myLocationEnabled: true,
//             compassEnabled: true,
//           ),
//           // Top left arrow back button
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 12, top: 10),
//               child: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Go back to previous screen
//                 },
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 style: IconButton.styleFrom(
//                   // backgroundColor: Colors.black54,
//                   shape: const CircleBorder(),
//                 ),
//               ),
//             ),
//           ),
//           // Search bar positioned at top
//           Positioned(
//             top: 100,
//             left: 25,
//             child: Container(
//               width: 350,
//               height: 55,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Image.asset(
//                     'assets/images/Search.png',
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Search Location',
//                     style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Location details card
//           Positioned(
//             top: 500,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 22),
//               child: Container(
//                 height: 160,
//                 width: 350,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Location Details',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 18),
//                     Row(
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.purple.withOpacity(0.1),
//                           ),
//                           child: Image.asset('assets/images/Location.png'),
//                         ),
//                         const SizedBox(width: 10),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Jl. Jend. Sudirman, Gowongan,',
//                               softWrap: true,
//                               style: const TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 14,
//                                 color: Color(0xFF666666),
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text(
//                               ' Kec. Jetis, Kota Yogyakarta',
//                               softWrap: true,
//                               style: const TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 14,
//                                 color: Color(0xFF666666),
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Choose location button at bottom
//           Positioned(
//             bottom: 30, // Changed from top: 680 to bottom: 30 for better responsiveness
//             left: 20,
//             child: Container(
//               width: 355,
//               height: 70,
//               child: ReusableButton(text: 'Choose location'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lt2;
import 'package:real_estate_app/Service/location_service.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LocationService _locationService = LocationService();
  late MapController mapController;
  late double latitude = _locationService.currentPosition?.latitude ?? 23.026347;
  late double longitude = _locationService.currentPosition?.longitude ?? 72.477161;
  late final lt2.LatLng _center = lt2.LatLng(latitude, longitude); // Example: Ahmedabad, India

  @override
  void initState() {
    super.initState();
    _locationService.getLocationAndSaveToFirebase();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
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
                    point: _center,
                    child: Icon(Icons.location_on, color: commonColor, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // Top left arrow back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ),

          // Search bar positioned at top
          Positioned(
            top: 100,
            left: 25,
            child: Container(
              width: 350,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Search.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Search Location',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Location details card
          Positioned(
            top:  550,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Container(
                height: 140,
                width: 350,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.withOpacity(0.1),
                          ),
                          child: Image.asset('assets/images/Location.png'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _locationService.locationMessage.toString(),
                              softWrap: true,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Choose location button at bottom
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              width: 355,
              height: 70,
              child: ReusableButton(text: 'Choose location'),
            ),
          ),
        ],
      ),
    );
  }
}