import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/ui/base_widiget/text_field.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:byat_flutter/util/extensions.dart';
import 'package:provider/provider.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({super.key, required this.controller});
  final PagingController controller;
  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  late final SearchProvider _searchProvider;
  final slideUpTween =
      Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0));
  @override
  void initState() {
    super.initState();
    _initControllers();
    _attachListener();
  }

  @override
  void dispose() {
    _searchProvider.searchController!.dispose();
    _searchProvider.searchFocusNode!.dispose();
    super.dispose();
  }

  //Initializing controllers
  _initControllers() {
    _searchProvider = context.read<SearchProvider>();
    _searchProvider.searchController = TextEditingController();
    _searchProvider.searchFocusNode = FocusNode();
  }

  //Attaching Listeners
  _attachListener() {
    _searchProvider.searchController!.addListener(_searchControllerListener);
    _searchProvider.searchFocusNode!.addListener(() {
      _searchProvider.saveSearchHistory();
      // if (!_searchProvider.hasFocus) {
      //   _searchProvider.toggleSearch();
      // }
    });
  }

  _searchControllerListener() {
    _searchProvider.searchContentByName(_searchProvider.text);
    if (_searchProvider.text!.isNotEmpty) {
      widget.controller.refresh();
    }
  }

  _onEditingComplete() {
    _searchProvider.toggleSearch();
    _searchProvider.unfocusField();
  }

  _onSearchCloseTap() {
    if (_searchProvider.hasFocus) {
      _searchProvider.clearText();
      _searchProvider.unfocusField();
    }
    _searchProvider.toggleSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SearchProvider, bool>(
        selector: (_, provider) => provider.isSearching,
        builder: (context, isSearching, child) {
          return AnimatedSwitcher(
            switchInCurve: Curves.fastOutSlowIn,
            switchOutCurve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 300),
            transitionBuilder: ((child, animation) {
              var slideAnimation = slideUpTween.animate(animation);
              return SlideTransition(
                position: slideAnimation,
                child: child,
              );
            }),
            child: !isSearching
                ? _buildSearchIcon(context)
                : _buildSearchTextField(context),
          );
        });
  }

  Align _buildSearchIcon(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: IconButton(
          color: context.onPrimaryColor,
          icon: const Icon(Icons.search),
          onPressed: () {
            _searchProvider.toggleSearch();
            _searchProvider.focus();
          },
        ),
      ),
    );
  }

  Container _buildSearchTextField(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: ByatColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ByatTextField(
        onEditingComplete: _onEditingComplete,
        showBorder: false,
        controller: _searchProvider.searchController,
        focusNode: _searchProvider.searchFocusNode,
        suffixIconColor: Theme.of(context).colorScheme.onPrimary,
        textColor: Theme.of(context).colorScheme.primary,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _onSearchCloseTap,
        ),
      ),
    );
  }
}
