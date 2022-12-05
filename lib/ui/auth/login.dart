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
  late final AuthProvider _authProvider;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _pageController = PageController(initialPage: 0);
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
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      children: [
         SwipeToLoginUI(pageController: _pageController),
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(height: 8),
                  Text('app_title'.tr(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w700)),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('sign_in'.tr(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700))),
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
                    child: ByatElevatedButton(
                      title: 'sign_in'.tr(),
                      onTap: () {
                        context.read<AuthProvider>().login(
                            emailController.text, passwordController.text);
                      },
                      hasSuffixIcon: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
