// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Added for date formatting
// import 'package:real_estate_app/widgets/reusable_button.dart';
// import 'package:real_estate_app/widgets/reusable_text_field.dart';
//
// import '../../Service/auth_service.dart';
// import '../../constant/constant_color.dart';
// import '../home_screen.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   // AuthService _authService = AuthService();
//   User? _currentUser = FirebaseAuth.instance.currentUser;
//   final _formKey = GlobalKey<FormState>();
//   // final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   //String imageUrl =
//   //    'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
//   String imageUrl = '';
//   Map<String, dynamic>? _userData;
//   DateTime? _selectedDate;
//   Future<void> _loadUserData() async {
//     if (_currentUser == null) return;
//
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_currentUser!.uid)
//           .get();
//
//       if (userDoc.exists) {
//         setState(() {
//           _userData = userDoc.data() as Map<String, dynamic>?;
//           _isLoading = false;
//
//           _userNameController.text = _currentUser!.displayName ?? '';
//           imageUrl = _currentUser!.photoURL ?? '';
//           _dobController.text = _userData?['DOB'] ?? '';
//
//           // Parse the date string if it exists
//           if (_userData?['DOB'] != null && _userData?['DOB'] != '') {
//             try {
//               _selectedDate = DateFormat('yyyy-MM-dd').parse(_userData?['DOB']);
//             } catch (e) {
//               // Handle case where date format is different
//               _selectedDate = null;
//             }
//           }
//
//           _emailController.text = _currentUser!.email!;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading profile: ${e.toString()}')),
//       );
//     }
//   }
//
//   bool _isLoading = false;
//
//   Future<void> _saveUserData() async {
//     if (_currentUser == null) return;
//
//     try {
//       Map<String, dynamic> updateData = {
//         'name': _userNameController.text.trim(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'DOB': _dobController.text.trim(),
//       };
//
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(_currentUser!.uid)
//           .update(updateData);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Profile updated successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error saving: ${e.toString()}')));
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with sample data or fetch from user profile
//     // _nameController.text = 'Rain Stream';
//     _loadUserData();
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: commonColor,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _emailController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           'Edit Profile',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ProfilePic(imageUrl: imageUrl),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
//                 child: ReusableTextField(
//                   labelText: 'User Name',
//                   controller: _userNameController,
//                   Tstyle: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a username';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
//                 child: ReusableTextField(
//                   labelText: 'Email',
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   Tstyle: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   validator: (value) {
//                   },
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
//                 child: GestureDetector(
//                   onTap: () => _selectDate(context),
//                   child: AbsorbPointer(
//                     child: ReusableTextField(
//                       labelText: 'Date of birth',
//                       controller: _dobController,
//                       suffixIcon: Icon(
//                         Icons.calendar_month,
//                         color: commonColor,
//                       ),
//                       Tstyle: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your date of birth';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: ReusableButton(
//                   text: _isLoading ? 'Saving...' : 'Save Changes',
//                   onPressed: _isLoading ? null : _saveUserData,
//                   isLoading: _isLoading,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ProfilePic extends StatefulWidget {
//   final String imageUrl;
//   const ProfilePic({Key? key, required this.imageUrl}) : super(key: key);
//
//   @override
//   State<ProfilePic> createState() => _ProfilePicState();
// }
//
// class _ProfilePicState extends State<ProfilePic> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       width: 100,
//       child: Stack(
//         fit: StackFit.expand,
//         clipBehavior: Clip.none,
//         children: [
//           CircleAvatar(
//             backgroundImage: widget.imageUrl.isNotEmpty
//                 ? NetworkImage(widget.imageUrl)
//                 : NetworkImage(
//                     'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1331&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//                   ),
//           ),
//           Positioned(
//             right: -0,
//             bottom: 3,
//             child: SizedBox(
//               height: 35,
//               width: 35,
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                     side: const BorderSide(color: Colors.deepPurpleAccent),
//                   ),
//                 ),
//                 onPressed: _selectImage,
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.deepPurpleAccent,
//                   size: 18,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _selectImage() async {
//     // TODO: Implement actual image selection using image_picker package
//     // For now, showing a simple dialog to simulate the selection
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Change Profile Picture'),
//           content: const Text(
//             'In a real implementation, this would open the camera or gallery.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for date formatting
import 'package:real_estate_app/widgets/reusable_button.dart';
import 'package:real_estate_app/widgets/reusable_text_field.dart';

import '../../Service/auth_service.dart';
import '../../constant/constant_color.dart';
import '../home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? _currentUser = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? imageUrl;
  Map<String, dynamic>? _userData;
  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;
          _isLoading = false;

          _userNameController.text = _currentUser!.displayName ?? '';
          imageUrl = _currentUser!.photoURL ?? '';
          _dobController.text = _userData?['DOB'] ?? '';

          if (_userData?['DOB'] != null && _userData?['DOB'] != '') {
            try {
              _selectedDate = DateFormat('yyyy-MM-dd').parse(_userData?['DOB']);
            } catch (e) {
              _selectedDate = null;
            }
          }

          _emailController.text = _currentUser!.email!;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: ${e.toString()}')),
      );
    }
  }

  Future<void> _saveUserData() async {
    if (_currentUser == null) return;

    try {
      Map<String, dynamic> updateData = {
        'name': _userNameController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        'DOB': _dobController.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Profile updated successfully!'),backgroundColor: commonColor,),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving: ${e.toString()}'),backgroundColor: Colors.red ,));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = _selectedDate ?? DateTime.now();
    DateTime selectedDate = initialDate;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Theme(

                data: ThemeData(
                  primaryColor: Colors.white,
                  focusColor: Colors.white,
                  // colorScheme: commonColor,
                  cardColor: Colors.white,
                  canvasColor: Colors.white,
                  scaffoldBackgroundColor: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Update parent state and close
                              if (selectedDate != _selectedDate) {
                                setState(() {
                                  _selectedDate = selectedDate;
                                  _dobController.text = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(selectedDate);
                                });
                              }
                              Navigator.pop(sheetContext);
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        onDateChanged: (DateTime newDate) {
                          selectedDate = newDate;
                        },
                      ),
                    ),
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
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePic(imageUrl: imageUrl ?? ''),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: ReusableTextField(
                  labelText: 'User Name',
                  controller: _userNameController,
                  Tstyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: ReusableTextField(
                  labelText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  Tstyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  validator: (value) {
                    // Validation commented out as in your original
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: ReusableTextField(
                      labelText: 'Date of birth',
                      controller: _dobController,
                      suffixIcon: Icon(
                        Icons.calendar_month,
                        color: commonColor,
                      ),
                      Tstyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ReusableButton(
                  text: _isLoading ? 'Saving...' : 'Save Changes',
                  onPressed: _isLoading ? null : _saveUserData,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  final String imageUrl;
  const ProfilePic({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  // ✅ Make _selectDate accessible from ProfilePic
  void _selectImage() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Profile Picture'),
          content: const Text(
            'In a real implementation, this would open the camera or gallery.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: widget.imageUrl.isNotEmpty
                ? NetworkImage(widget.imageUrl)
                : AssetImage('assets/images/Profile.png'),
          ),
          Positioned(
            right: -0,
            bottom: 3,
            child: SizedBox(
              height: 35,
              width: 35,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
                onPressed: _selectImage,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.deepPurpleAccent,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
