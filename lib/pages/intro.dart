import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(107, 254, 122, 0.33),
                  Color.fromRGBO(254, 193, 122, 0.76270),
                  Color.fromRGBO(253, 195, 126, 0.39)
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.0, -0.65),
            child: Image.asset(
              'assets/images/misc/ellipse.png',
              scale: 0.85,
              alignment: const AlignmentDirectional(0.0, -0.65),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(0.0, -0.60),
            child: Text(
              'Relax',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'LibreBaskerville',
              ),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(0.0, -0.45),
            child: Text(
              'Refresh',
              style: TextStyle(fontSize: 40, fontFamily: 'LibreBaskerville'),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(0.0, -0.30),
            child: Text(
              'Reassure',
              style: TextStyle(fontSize: 40, fontFamily: 'LibreBaskerville'),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.70, -0.85),
            child: Image.asset('assets/images/misc/plant.png'),
          ),
          Align(
            alignment: const AlignmentDirectional(-0.75, 0.20),
            child: Image.asset('assets/images/misc/potted_plant.png'),
          ),
          Align(
            alignment: const AlignmentDirectional(0.75, 0.18),
            child: Image.asset('assets/images/misc/sofa.png'),
          ),
          Align(
            alignment: const AlignmentDirectional(0.75, 0.35),
            child: Image.asset(
              'assets/images/misc/line.png',
              width: 230.0,
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(0.50, 0.42),
            child: Text(
              'Breath in.',
              style: TextStyle(fontSize: 23, fontFamily: 'LibreBaskerville'),
            ),
          ),
          const Align(
            alignment: AlignmentDirectional(0.50, 0.50),
            child: Text(
              'Breath out.',
              style: TextStyle(fontSize: 23, fontFamily: 'LibreBaskerville'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: const Alignment(0.0, 0.85),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 50.0,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
