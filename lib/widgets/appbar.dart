import 'package:flutter/material.dart';

class ReliefAppBar extends StatefulWidget implements PreferredSizeWidget {

  final bool isScreenshot;
  const ReliefAppBar({
    super.key,
    this.isScreenshot = false
  });

  @override
  State<ReliefAppBar> createState() => _ReliefAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ReliefAppBarState extends State<ReliefAppBar> {
  bool showMenuButton = true;

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    Map? settings = ModalRoute.of(context)?.settings.arguments as Map?;
    showMenuButton = settings?['showMenuButton'] ?? true;

    return AppBar(
      centerTitle: true,
      title: Image.asset(
        'assets/images/icons/relief.png',
        height: 40.0,
      ),
      leading: Builder(builder: (BuildContext context) {
        if (!widget.isScreenshot) {
          if (showMenuButton) {
            return IconButton(
                onPressed: () {Navigator.pushNamed(context, '/menu');},
                icon: Image.asset(
                  'assets/images/icons/menu.png',
                  height: 30.0,
                )
            );
          } else {
            return IconButton(
                onPressed: () {Navigator.pop(context);},
                icon: const Icon(Icons.arrow_back_ios_new_rounded)
            );
          }
        } else {
          return const SizedBox.shrink();
        }
      },),
    );
  }
}
