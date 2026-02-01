import 'package:flutter/material.dart';

class SliverAppbarExample extends StatefulWidget {
  const SliverAppbarExample({super.key});

  @override
  State<SliverAppbarExample> createState() => _SliverAppbarExampleState();
}

class _SliverAppbarExampleState extends State<SliverAppbarExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(

          )
        ],
      ),
    );
  }
}
