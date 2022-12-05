import 'package:byat_flutter/mock_data.dart';
import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  FilterProvider() {
    filterOnlyNationality();

    startDate = users.first.date;
    endDate = users.last.date;
  }
  // SearchProvider? searchProvider;

  final nationality = <String>[];
  UserModel? selectedUserModel;
  List<UserModel> users = userData;
  String selectedNationality = 'All';
  DateTime? startDate, endDate;

  onUserSelect(UserModel user) {
    selectedUserModel = user;
    notifyListeners();
  }

  filterOnlyNationality() {
    for (var user in userData) {
      if (!nationality.contains(user.nationality)) {
        nationality.add(user.nationality);
      }
    }
    if (nationality.isNotEmpty) nationality.add('All');
  }

  onNationalitySelect(String? selectedItem) {
    if (selectedItem != null) {
      selectedNationality = selectedItem;
      notifyListeners();
    }
  }

  List<UserModel> getAllUsers() => userData;
  List<UserModel> getSelectedNationalityUsers() => userData
      .where((item) => item.nationality == selectedNationality)
      .toList();

  setDateRange(DateTimeRange range) {
    if (startDate == null && endDate == null) return null;
    startDate = range.start;
    endDate = range.end;
    notifyListeners();
  }

  findUsersFromDateRange(DateTime startDate, DateTime endDate) {
    return users.where((element) {
      final isStartDateSame = element.date.isAtSameMomentAs(startDate);
      final isEndDateSame = element.date.isAtSameMomentAs(endDate);
      final isDateAfter = element.date.isAfter(startDate);
      final isDateBefore = element.date.isBefore(endDate);
      if ((isStartDateSame || isDateAfter) && (isDateBefore || isEndDateSame)) {
        return true;
      }
      return false;
    }).toList();
  }

  onResetFilter() {
    selectedNationality = 'All';
    users = getAllUsers();
    startDate = users.first.date;
    endDate = users.last.date;
    notifyListeners();
  }

  onApplyFilter() {
    users = (selectedNationality == 'All')
        ? getAllUsers()
        : getSelectedNationalityUsers();

    if (startDate != null && endDate != null) {
      users = findUsersFromDateRange(startDate!, endDate!);
    }
    notifyListeners();
  }

  List<UserModel> getRangeOfData(int start, int end) =>
      users.getRange(start, end).toList();
}
