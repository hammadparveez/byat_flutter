extension StringExtension on String {
  String toCapitalize() => this[0].toUpperCase() + substring(1).toLowerCase();
}

extension ListExtension on List {
  List<String> modifyToLowerCase() =>
      map((e) => (e as String).toLowerCase()).toList();
  List<String> modifyToUpperCase() =>
      map((e) => (e as String).toLowerCase()).toList();
  List<String> modifyToCapitalize() =>
      map((e) => (e as String).toCapitalize()).toList();
}
