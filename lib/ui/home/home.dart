import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/provider/filter_provider.dart';

import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/routes.dart';
import 'package:byat_flutter/ui/base_widiget/custom_badge.dart';
import 'package:byat_flutter/ui/base_widiget/elevated_button.dart';

import 'package:byat_flutter/ui//home/components/filter_sheet.dart';
import 'package:byat_flutter/ui/home/components/animated_search_bar.dart';
import 'package:byat_flutter/ui/home/components/saved_searches.dart';
import 'package:byat_flutter/ui/home/components/users_listview.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:byat_flutter/util/extensions.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});
  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final PagingController<int, UserModel> _pagingController =
      PagingController(firstPageKey: 0);
  late final SearchProvider _searchProvider;
  final perPageNumberOfItems = 5;

  @override
  initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchItems);
  }

  //Disposing controllers and listeners
  @override
  dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  ///Fetches Items lazily from Mock Data
  void _fetchItems(int pageIndex) async {
    final filter = context.read<FilterProvider>();
    //to show a loader for 2 seconds;
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    bool isLastPage = checkIfLastPage(pageIndex);
    final maxSize =
        isLastPage ? filter.users.length : (perPageNumberOfItems + pageIndex);
    final items = filter.getRangeOfData(pageIndex, maxSize);

    if (isLastPage) {
      _pagingController.appendLastPage(items);
    } else {
      final nextPageIndex = perPageNumberOfItems + pageIndex;
      _pagingController.appendPage(items, nextPageIndex);
    }
  }

  bool checkIfLastPage(int pageIndex) {
    return pageIndex + perPageNumberOfItems <
            context.read<FilterProvider>().users.length
        ? false
        : true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(_pagingController),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                builder: (_) => FilterSheet(pageController: _pagingController)),
            label: Text('filter'.tr()),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              UsersListView(controller: _pagingController),
              SavedSearches(onClearHistory: _pagingController.refresh),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(PagingController controller) {
    const shadow = BoxShadow(blurRadius: 10, color: ByatColors.darkGrey);
    return Container(
      decoration: BoxDecoration(
        color: context.primaryColor,
        boxShadow: const [shadow],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, context.topInsetPadding, 8, 0),
        child: AnimatedSearchBar(controller: controller),
      ),
    );
  }
}

