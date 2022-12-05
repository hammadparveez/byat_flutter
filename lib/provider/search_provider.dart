import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/main.dart';
import 'package:byat_flutter/mock_data.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:byat_flutter/util/extensions.dart';

class SearchProvider extends ChangeNotifier {
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  FilterProvider? filterProvider;
  final savedHistoryMaxLength = 12;
  List<String> searchedHistory = [];
  SearchProvider();

  void update(FilterProvider provider) => filterProvider = provider;
  void searchContentByName(String? name) {
    final filter = filterProvider!;
    filter.users = _getSearchedUsers(name);

    if (filter.users.isNotEmpty &&
        filter.startDate != null &&
        filter.endDate != null) {
      filter.users =
          filter.findUsersFromDateRange(filter.startDate!, filter.endDate!);
    }
    notifyListeners();
  }

  List<UserModel> _getSearchedUsers(String? name) {
    return filterProvider!.getAllUsers().where((item) {
      final username = item.name.toLowerCase();
      final hasAllNationality = filterProvider!.selectedNationality == 'All';

      bool containsName = username.contains((name?.toLowerCase() ?? ''));
      bool constainsNationality = hasAllNationality
          ? true
          : (filterProvider!.selectedNationality == item.nationality);

      return (containsName && constainsNationality) ? true : false;
    }).toList();
  }

  saveSearchHistory() {
    final history = pref!.getStringList(SEARCHED_HISTORY_KEY) ?? [];
    if (!searchFocusNode!.hasFocus) {
      if (pref != null) {
        final text = searchController!.text.toLowerCase();
        if (text.length > 1 && history.length < savedHistoryMaxLength) {
          if (!history.contains(text)) {
            history.add(text);
            pref!.setStringList(SEARCHED_HISTORY_KEY, history);
          }
        }
      }
    }
    searchedHistory = history.modifyToCapitalize();
    notifyListeners();
  }

  onSavedHistoryTagTap(String text) {
    searchController!.text = text;
    searchFocusNode!.unfocus();
    filterProvider?.users = filterProvider!.users
        .where((item) => item.name
            .toLowerCase()
            .contains(searchController!.text.toLowerCase()))
        .toList();
  }

  clearSearchHistory() async {
    searchController!.clear();
    searchFocusNode!.unfocus();
    await pref?.remove(SEARCHED_HISTORY_KEY);
    searchedHistory.clear();
    notifyListeners();
  }
}
