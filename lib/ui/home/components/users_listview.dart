import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/routes.dart';
import 'package:byat_flutter/ui/base_widiget/elevated_button.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:byat_flutter/util/extensions.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key, required this.controller});

  final PagingController<int, UserModel> controller;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterProvider, SearchProvider>(
        builder: (context, filter, searchProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PagedListView<int, UserModel>.separated(
          padding: EdgeInsets.zero,
          pagingController: controller,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          builderDelegate: PagedChildBuilderDelegate(
              animateTransitions: true,
              noItemsFoundIndicatorBuilder: _buildNoItemFoundMsg,
              firstPageProgressIndicatorBuilder: _buildCustomPaginationLoader,
              itemBuilder: (_, user, index) {
                return GestureDetector(
                  onTap: () {
                    filter.onUserSelect(user);
                    Navigator.pushNamed(context, ByatRoute.userDetail);
                  },
                  child: _UserItemCard(user: user),
                );
              }),
        ),
      );
    });
  }

  Widget _buildNoItemFoundMsg(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('We are sorry!', style: context.textTheme.headline5),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Byat could not find anything'),
          ),
          ByatElevatedButton(title: 'Tap to reload', onTap: controller.refresh),
        ],
      );

  Widget _buildCustomPaginationLoader(BuildContext _) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Byat Loading...'),
        ],
      );
}

class _UserItemCard extends StatelessWidget {
  const _UserItemCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().format(user.date);
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.onPrimary),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: ByatColors.primaryDark)
                ],
                image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/home.jpg'))),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: context.textTheme.headline5
                    ?.copyWith(color: context.onPrimaryColor),
              ),
              Text(
                user.nationality,
                style: TextStyle(height: 1.5, color: context.onPrimaryColor),
              ),
              _buildDivider(),
              const Spacer(),
              Text(
                'Date: $date',
                style: TextStyle(color: context.onPrimaryColor),
              )
            ],
          ),
          const Spacer(),
          Material(
            clipBehavior: Clip.hardEdge,
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            child: IconButton(
                splashColor: ByatColors.primaryDark,
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded)),
          )
        ],
      ),
    );
  }

  SizedBox _buildDivider() {
    return const SizedBox(
      width: 30,
      child: Divider(
        thickness: 2,
        color: ByatColors.white,
      ),
    );
  }
}
