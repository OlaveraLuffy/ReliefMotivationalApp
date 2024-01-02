import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(221, 255, 218, 0.7),
                  Color.fromRGBO(97, 250, 60, 0.7),
                  Color.fromRGBO(97, 250, 60, 0.7),
                  Color.fromRGBO(254, 220, 180, 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: const AlignmentDirectional(0.0, -0.40),
                child: Image.asset(
                  'assets/images/logos/relief_logo.png',
                  height: 450,
                  width: 450,
                ),
              ),
              Container(
                alignment: const AlignmentDirectional(0.0, 0.75),
                child: const Text(
                  'Motivate Your Day',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'LibreBaskerville',
                  ),
                ),
              ),
              Container(
                alignment: const AlignmentDirectional(0.0, 0.85),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 50.0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/intro');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
