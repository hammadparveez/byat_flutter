import 'package:byat_flutter/provider/search_provider.dart';
import 'package:byat_flutter/ui/base_widiget/custom_badge.dart';
import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedSearches extends StatelessWidget {
  const SavedSearches({
    Key? key,
    this.onClearHistory,
    this.onHistoryTagTap,
  }) : super(key: key);

  final VoidCallback? onHistoryTagTap, onClearHistory;
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      final hasNotFocus = !searchProvider.hasFocus;
      final isHistoryEmpty = searchProvider.searchedHistory.isEmpty;
      if (hasNotFocus || isHistoryEmpty) return const SizedBox();
      return Positioned(
        child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)),
            builder: (context, offset, child) {
              return AnimatedSlide(
                duration: const Duration(seconds: 0),
                offset: offset,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      _buildSavedBadge(searchProvider),
                      const Divider(),
                      _buildClearHistoryButton(searchProvider),
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }

  Align _buildClearHistoryButton(SearchProvider searchProvider) {
    return Align(
        alignment: Alignment.bottomRight,
        child: CustomBadge(
          title: 'Clear history',
          onTap: () {
            searchProvider.clearSearchHistory();
            if (onClearHistory != null) onClearHistory!();
          },
          backgroundColor: ByatColors.ligtGrey,
          titleColor: ByatColors.black,
        ));
  }

  Wrap _buildSavedBadge(SearchProvider searchProvider) {
    return Wrap(
      children: searchProvider.searchedHistory
          .map((e) => CustomBadge(
                title: e,
                onTap: () {
                  searchProvider.onSavedHistoryTagTap(e);
                  if (onHistoryTagTap != null) {
                    onHistoryTagTap!();
                  }
                },
              ))
          .toList(),
    );
  }
}
