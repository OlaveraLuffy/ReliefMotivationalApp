import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 48,
                weight: 700,
                color: Colors.black,
              )),
          Expanded(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/home');
                    },
                    child: Text(
                      'HOME',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    )),
                Divider(
                  height: 80,
                  indent: 70,
                  endIndent: 70,
                  thickness: 3,
                  color: Theme.of(context).primaryColorDark,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, '/gallery');
                    },
                    child: Text(
                      'QUOTE GALLERY',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    )),
                Divider(
                  height: 80,
                  indent: 70,
                  endIndent: 70,
                  thickness: 3,
                  color: Theme.of(context).primaryColorDark,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/journal');
                    },
                    child: Text(
                      'JOURNAL',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    )),
                Divider(
                  height: 80,
                  indent: 70,
                  endIndent: 70,
                  thickness: 3,
                  color: Theme.of(context).primaryColorDark,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/settings');
                    },
                    child: Text(
                      'SETTINGS',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    )),
                Divider(
                  height: 80,
                  indent: 70,
                  endIndent: 70,
                  thickness: 3,
                  color: Theme.of(context).primaryColorDark,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/onboard');
                    },
                    child: Text(
                      'HELP',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    )),
              ],
            )),
          )
        ],
      ),
    ));
  }
}
