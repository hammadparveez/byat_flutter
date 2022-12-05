import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
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
          return Scaffold(
            appBar: AppBar(
                title: Text(
              user?.name ?? "",
            )),
            body: Center(child: Text("${user?.nationality}")),
          );
        });
  }
}
