import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_animations/simple_animations.dart';

class SwipeToLoginUI extends StatefulWidget {
  const SwipeToLoginUI({super.key, required this.pageController});
  final PageController pageController;
  @override
  State<SwipeToLoginUI> createState() => _SwipeToLoginUIState();
}

class _SwipeToLoginUIState extends State<SwipeToLoginUI> {
  double spacing = 0;
  @override
  initState() {
    super.initState();
    _onPageChange();
  }

  _onPageChange() {
    widget.pageController.addListener(() {
      final pos = widget.pageController.position;
      final isScrolledPixellLess = pos.pixels <= (pos.maxScrollExtent / 2) && pos.pixels > pos.minScrollExtent;
  
      if (pos.userScrollDirection == ScrollDirection.reverse) {
        if(isScrolledPixellLess) {
          // spacing += 2;
        } else {
          // spacing += 1;
        }
      } else  {
        if(!isScrolledPixellLess) {
          // spacing -= 2;
        } else {
          // spacing -= 1;
        }
      }
      // setState(() {});
      debugPrint(
          'Swiping... Axis ${pos.pixels} | ${pos.minScrollExtent} | ${pos.maxScrollExtent}  || User Scroll ${pos.userScrollDirection}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          ByatColors.primary,
          ByatColors.primaryDark,
        ])),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ByatColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset('assets/images/logo.png',
                      width: 50, height: 50),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MirrorAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0, end: -10),
                      curve: Curves.decelerate,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, value),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ByatColors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.arrow_upward,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Swipe up to Log In',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    SizedBox(height: spacing),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
