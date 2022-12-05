import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/ui/base_widiget/text_field.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AnimatedSearchBar extends StatelessWidget {
  const AnimatedSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<SearchProvider, bool>(
        selector: (_, provider) => provider.isSearching == true,
        builder: (context, isSearching, child) {
          return AnimatedSwitcher(
            switchInCurve: Curves.fastOutSlowIn,
            switchOutCurve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 300),
            transitionBuilder: ((child, animation) {
              var slideAnimation = Tween<Offset>(
                      begin: const Offset(0, -1), end: const Offset(0, 0))
                  .animate(animation);
              return SlideTransition(
                position: slideAnimation,
                child: child,
              );
            }),
            child: !isSearching
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: IconButton(
                        color: Theme.of(context).colorScheme.onPrimary,
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          var searchProvier = context.read<SearchProvider>();
                          searchProvier.toggleSearch();
                          searchProvier.searchFocusNode!.requestFocus();
                        },
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: ByatColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ByatTextField(
                      focusNode: context.read<SearchProvider>().searchFocusNode,
                      showBorder: false,
                      suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                      textColor: Theme.of(context).colorScheme.primary,
                      cursorColor: Theme.of(context).colorScheme.onPrimary,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          final searchProvider = context.read<SearchProvider>();
                          if (searchProvider.searchFocusNode?.hasFocus ??
                              false) {
                            searchProvider.searchController!.clear();
                            searchProvider.searchFocusNode!.unfocus();
                          }
                          searchProvider.toggleSearch();
                        },
                      ),
                    ),
                  ),
          );
        });
  }
}
