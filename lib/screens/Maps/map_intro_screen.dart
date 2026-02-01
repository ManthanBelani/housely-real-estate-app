import 'package:flutter/material.dart';
import 'package:real_estate_app/constant/constant_color.dart';
import 'package:real_estate_app/widgets/reusable_button.dart';

class MapIntroScreen extends StatefulWidget {
  const MapIntroScreen({super.key});

  @override
  State<MapIntroScreen> createState() => _MapIntroScreenState();
}

class _MapIntroScreenState extends State<MapIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Skip',style: TextStyle(color: Colors.black,fontSize: 15),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image.asset('assets/images/mapintro.png',height: 500,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableButton(text: 'Use current location'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: commonColor,
                disabledBackgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: commonColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: false
                  ? CircularProgressIndicator(color: commonColor)
                  : Text(
                      'Select it manually',
                      style: TextStyle(
                        fontSize: 18,
                        color: commonColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
