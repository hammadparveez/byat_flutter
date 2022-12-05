import 'package:byat_flutter/domain/model/user_model.dart';
import 'package:byat_flutter/mock_data.dart';
import 'package:byat_flutter/provider/filter_provider.dart';
import 'package:byat_flutter/provider/search_provider.dart';

import 'package:byat_flutter/ui/base_widiget/elevated_button.dart';
import 'package:byat_flutter/ui/home/components/filter_card.dart';
import 'package:byat_flutter/ui/home/components/filter_dropdown.dart';

import 'package:byat_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key, required this.pageController});
  final PagingController pageController;
  _onFilterApply(BuildContext context) {
    final filterProvider = context.read<FilterProvider>();
    final searchProvider = context.read<SearchProvider>();

    if (searchProvider.searchController!.text.isNotEmpty) {
      searchProvider.searchContentByName(searchProvider.searchController!.text);
    } else {
      filterProvider.onApplyFilter();
    }
    pageController.refresh();
    Navigator.pop(context);
  }

  _onResetFilter(BuildContext context) {
    context.read<FilterProvider>().onResetFilter();
    pageController.refresh();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      height: MediaQuery.of(context).size.height * .65,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _filterByNationality(),
            _filterDateRange(context),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ByatElevatedButton(
                    backgroundColor: ByatColors.darkGrey,
                    title: 'Reset',
                    onTap: () => _onResetFilter(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ByatElevatedButton(
                    title: 'Apply Filter',
                    onTap: () => _onFilterApply(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _openDateRangeSelector(BuildContext context) async {
    final filterProvider = context.read<FilterProvider>();
    List<UserModel> data = [];
    data = (filterProvider.selectedNationality == 'All')
        ? filterProvider.getAllUsers()
        : filterProvider.getSelectedNationalityUsers();

    final range = await showDateRangePicker(
        context: context,
        locale: context.locale,
        builder: (_, widget) => Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  height: MediaQuery.of(context).size.height * .85,
                  child: widget),
            ),
        currentDate: filterProvider.startDate,
        firstDate: data.first.date,
        lastDate: data.last.date);
    if (range != null) {
      filterProvider.setDateRange(range);
    }
  }

  FilterCard _filterDateRange(BuildContext context) {
    return FilterCard(
        child: Consumer<FilterProvider>(builder: (_, filterProvider, child) {
      return Row(
        children: [
          DateRangeCard(time: filterProvider.startDate!),
          LayoutBuilder(builder: (context, constraints) {
            debugPrint('-> $constraints');
            return const SizedBox(
                height: 50, child: VerticalDivider(color: ByatColors.white));
          }),
          DateRangeCard(time: filterProvider.endDate!),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ByatColors.primaryDark,
              ),
              child: ByatElevatedButton(
                  title: 'Change Date',
                  onTap: () => _openDateRangeSelector(context)),
            ),
          ),
        ],
      );
    }));
  }

  FilterCard _filterByNationality() {
    return FilterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('filter_by_nationality'.tr()),
          Consumer<FilterProvider>(builder: (context, filter, child) {
            return FilterDropDown(
              value: filter.selectedNationality,
              dropdownItems: filter.nationality,
              onDropdownSelect: filter.onNationalitySelect,
            );
          }),
        ],
      ),
    );
  }
}

class DateRangeCard extends StatelessWidget {
  const DateRangeCard({Key? key, required this.time}) : super(key: key);
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ByatColors.primaryDark,
      ),
      child: Column(
        children: [
          Text('${time.year}'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '${time.day}',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          Text(DateFormat.MMM().format(time)),
        ],
      ),
    );
  }
}
