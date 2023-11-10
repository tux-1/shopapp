import 'package:flutter/material.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});
  static const routeName = '/splash-screen';

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? fadingAnimation;

  void goToNextView() {
    // Navigator.of(context).pushNamed(routeName);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    fadingAnimation =
        Tween<double>(begin: .2, end: 1).animate(animationController!);

    animationController?.repeat(reverse: true);
    goToNextView();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1E352F),
        body: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: FadeTransition(
                  opacity: fadingAnimation!,
                  child: Image.asset('assets/Logo.png'),
                ),
              )
            ],
          ),
        ));
  }
}
