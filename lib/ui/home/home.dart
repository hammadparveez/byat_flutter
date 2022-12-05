import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/provider/filter_provider.dart';

import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/routes.dart';
import 'package:byat_flutter/ui/base_widiget/custom_badge.dart';
import 'package:byat_flutter/ui/base_widiget/text_field.dart';
import 'package:byat_flutter/ui//home/components/filter_sheet.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

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
    _initControllers();
    _attachListeners();
  }

  //Initializing controllers
  _initControllers() {
    _searchProvider = context.read<SearchProvider>();
    _searchProvider.searchController = TextEditingController();
    _searchProvider.searchFocusNode = FocusNode();
  }

  //Attaching event listeners
  _attachListeners() {
    _pagingController.addPageRequestListener(_fetchItems);
    _searchProvider.searchController!.addListener(_searchControllerListener);
    _searchProvider.searchFocusNode!
        .addListener(_searchProvider.saveSearchHistory);
  }

  _searchControllerListener() {
    final text = _searchProvider.searchController!.text;
    _searchProvider.searchContentByName(text);
    if (text.isNotEmpty) {
      _pagingController.refresh();
    }
  }

  //Disposing controllers and listeners
  @override
  dispose() {
    _pagingController.removePageRequestListener(_fetchItems);
    _pagingController.dispose();
    _searchProvider.searchController!.removeListener(_searchControllerListener);
    _searchProvider.searchController!.dispose();
    _searchProvider.searchFocusNode!.dispose();
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
        _buildTopBar(),
        Expanded(
          child: Stack(
            children: [
              _UsersListView(controller: _pagingController),
              _SavedSearches(onClearHistory: _pagingController.refresh),
            ],
          ),
        ),
      ],
    );
  }

  Material _buildTopBar() {
    final safeAreaPadding = MediaQuery.of(context).padding.top + 8;
    return Material(
      color: Theme.of(context).colorScheme.primary,
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, safeAreaPadding, 8, 0),
        child: Row(
          children: [
            Expanded(
              child: ByatTextField(
                  controller: context.read<SearchProvider>().searchController,
                  focusNode: context.read<SearchProvider>().searchFocusNode,
                  showBorder: false,
                  suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  suffixIcon: Consumer<SearchProvider>(
                      builder: (context, searchProvider, child) {
                    final hasFocus = searchProvider.searchFocusNode!.hasFocus;
                    return IconButton(
                      color: ByatColors.white,
                      icon: hasFocus
                          ? const Icon(Icons.close)
                          : const Icon(Icons.search),
                      onPressed: () {
                        if (hasFocus) {
                          searchProvider.searchController!.clear();
                        } else {
                          searchProvider.searchFocusNode!.requestFocus();
                        }
                      },
                    );
                  })),
            ),
            IconButton(
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) =>
                        FilterSheet(pageController: _pagingController)),
                icon: const Icon(Icons.filter_alt)),
          ],
        ),
      ),
    );
  }
}

class _UsersListView extends StatelessWidget {
  const _UsersListView({required this.controller});
  final PagingController<int, UserModel> controller;
  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterProvider, SearchProvider>(
        builder: (context, filter, searchProvider, child) {
      return PagedListView<int, UserModel>(
        pagingController: controller,
        builderDelegate:
            PagedChildBuilderDelegate(itemBuilder: (_, user, index) {
          final date = DateFormat.yMMMd().format(user.date);

          return ListTile(
            onTap: () {
              filter.onUserSelect(user);
              Navigator.pushNamed(context, ByatRoute.userDetail);
            },
            title: Text("${index} - ${user.name}"),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Date: $date'),
                const SizedBox(width: 8),
                Text('Nationality: ${user.nationality}'),
              ],
            ),
          );
        }),
      );
      // return ListView.separated(
      //     padding: const EdgeInsets.only(top: 20),
      //     itemCount: filter.duplicatedData.length,
      //     separatorBuilder: (_, index) => const Divider(),
      //     itemBuilder: (_, index) {
      //       final user = filter.duplicatedData[index];
      //       final date = DateFormat.yMMMd().format(user.date);
      //       return ListTile(
      //         onTap: () {
      //           filter.onUserSelect(user);
      //           Navigator.pushNamed(context, ByatRoute.userDetail);
      //         },
      //         title: Text(user.name.toLowerCase().tr()),
      //         trailing: Column(
      //           crossAxisAlignment: CrossAxisAlignment.end,
      //           children: [
      //             Text('Date: $date'),
      //             const SizedBox(width: 8),
      //             Text(
      //                 'Nationality: ${filter.duplicatedData[index].nationality}'),
      //           ],
      //         ),
      //       );
      //     });
    });
  }
}

class _SavedSearches extends StatelessWidget {
  const _SavedSearches({
    Key? key,
    this.onClearHistory,
    this.onHistoryTagTap,
  }) : super(key: key);

  final VoidCallback? onHistoryTagTap, onClearHistory;
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      final hasNotFocus = !searchProvider.searchFocusNode!.hasFocus;
      final isHistoryEmpty = searchProvider.searchedHistory.isEmpty;
      if (hasNotFocus || isHistoryEmpty) return const SizedBox();
      return Positioned(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              color: Color(0xFFE9E8E8)),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: searchProvider.searchedHistory
                    .map((e) => CustomBadge(
                          title: e,
                          onTap: () {
                            searchProvider.onSavedHistoryTagTap(e);
                            if (onHistoryTagTap != null) onHistoryTagTap!();
                          },
                        ))
                    .toList(),
              ),
              const Divider(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: CustomBadge(
                    title: 'Clear history',
                    onTap: () {
                      searchProvider.clearSearchHistory();
                      if (onClearHistory != null) onClearHistory!();
                    },
                    backgroundColor: ByatColors.ligtGrey,
                    titleColor: ByatColors.black,
                  )),
            ],
          ),
        ),
      );
    });
  }
}
