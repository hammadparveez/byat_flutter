import 'package:byat_flutter/provider/auth_provider.dart';
import 'package:byat_flutter/provider/locale_provider.dart';
import 'package:byat_flutter/routes.dart';
import 'package:byat_flutter/ui/auth/swipe_to_login.dart';
import 'package:byat_flutter/ui/base_widiget/elevated_button.dart';
import 'package:byat_flutter/ui/base_widiget/loader_dialog.dart';
import 'package:byat_flutter/ui/base_widiget/message_dialog.dart';
import 'package:byat_flutter/ui/base_widiget/text_field.dart';
import 'package:byat_flutter/util/colors.dart';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      children: [
        SwipeToLoginUI(pageController: _pageController),
        const _LoginUI(),
      ],
    );
  }
}

class _LoginUI extends StatefulWidget {
  const _LoginUI({Key? key}) : super(key: key);

  @override
  State<_LoginUI> createState() => __LoginUIState();
}

class __LoginUIState extends State<_LoginUI> {
  late final AuthProvider _authProvider;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _authProvider.addListener(_authStateListener);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_authStateListener);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _authStateListener() {
    final authProvider = context.read<AuthProvider>();

    switch (authProvider.authStatus) {
      case AuthStatus.loading:
        showDialog(
            context: context,
            builder: (_) => Loader(
                  title: 'authenticating'.tr(),
                ));
        break;
      case AuthStatus.authenticated:
        Navigator.pushNamedAndRemoveUntil(
            context, ByatRoute.home, (_) => false);

        break;
      case AuthStatus.failure:
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (_) => MessageDialog(
                title: authProvider.errorMsg?.tr() ??
                    'something_went_wrong'.tr()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: _AnimatedImageContainer()),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('sign_in'.tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 20),
                  ByatTextField(
                      hintText: 'example@byat.com',
                      controller: emailController,
                      prefixIcon: const Icon(Icons.email)),
                  const SizedBox(height: 20),
                  ByatTextField(
                      isPassword: true,
                      controller: passwordController,
                      prefixIcon: const Icon(Icons.lock)),
                  Align(
                    alignment: context.locale.languageCode == 'en'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: TextButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).brightness == Brightness.dark
                                    ? ByatColors.white
                                    : Theme.of(context).colorScheme.primary)),
                        onPressed: () =>
                            context.read<LocaleProvider>().toggleLang(context),
                        child: Text('lang'.tr())),
                  ),
                  FractionallySizedBox(
                    widthFactor: .7,
                    child: Hero(
                      tag: 'auth',
                      child: ByatElevatedButton(
                        title: 'sign_in'.tr(),
                        onTap: () {
                          context.read<AuthProvider>().login(
                              emailController.text, passwordController.text);
                        },
                        hasSuffixIcon: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedImageContainer extends StatelessWidget {
  const _AnimatedImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return TweenAnimationBuilder(
        tween: Tween(begin: -deviceWidth, end: 0.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return AnimatedContainer(
            curve: Curves.decelerate,
            transform: Matrix4.identity()..translate(value, 0),
            duration: const Duration(milliseconds: 800),
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 15),
                    color: ByatColors.ligtGrey.withOpacity(.2),
                    blurRadius: 10,
                    spreadRadius: 0.5)
              ],
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/home.jpg')),
            ),
          );
        });
  }
}
