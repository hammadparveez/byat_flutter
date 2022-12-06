import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class UserDetailUI extends StatelessWidget {
  const UserDetailUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<FilterProvider, UserModel?>(
        selector: (_, filterProvider) => filterProvider.selectedUserModel,
        builder: (context, user, child) {
          final index = ModalRoute.of(context)?.settings.arguments;
          debugPrint('Index $index');
          return Scaffold(
            appBar: AppBar(
                title: Text(
              user?.name ?? "",
            )),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'detail-$index',
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.onPrimary),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 5, color: ByatColors.primaryDark)
                            ],
                            image: const DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/home.jpg'))),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                  ],
                ),
              ),
            ),
          );
        });
  }
}
