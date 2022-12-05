import 'package:byat_flutter/domain/model/user_model.dart';

final userData = [
  UserModel('Hammad', DateTime.parse('2022-10-09'), 'Pakistan'),
  UserModel('Hammaz', DateTime.parse('2022-10-08'), 'Pakistan'),
  UserModel('Mason', DateTime.parse('2022-10-07'), 'India'),
  UserModel('Mason', DateTime.parse('2022-10-06'), 'India'),
  UserModel('MasHaon', DateTime.parse('2022-11-30'), 'India'),
  UserModel('Byat', DateTime.parse('2022-11-29'), 'Canada'),
  UserModel('James', DateTime.parse('2022-11-25'), 'USA'),
  UserModel('Bond', DateTime.parse('2022-11-25'), 'England'),
  UserModel('Lee', DateTime.parse('2022-11-30'), 'Denmark'),
  UserModel('Jesmine', DateTime.parse('2022-09-07'), 'Ukraine'),
  UserModel('Jose', DateTime.parse('2022-09-11'), 'Ukraine'),
  UserModel('Alex', DateTime.parse('2022-09-25'), 'Poland'),
  UserModel('Murphy', DateTime.parse('2022-10-08'), 'Netherland'),
  UserModel('Zain', DateTime.parse('2022-09-11'), 'Pakistan'),
  UserModel('Islam', DateTime.parse('2022-08-01'), 'Qatar'),
  UserModel('Jibran', DateTime.parse('2022-08-05'), 'UAE'),
  UserModel('Moiz', DateTime.parse('2022-08-10'), 'Qatar'),
  UserModel('Ahmed', DateTime.parse('2022-07-05'), 'Suadia Arabia'),
  UserModel('Ali', DateTime.parse('2022-07-15'), 'England'),
  UserModel('Ilyas', DateTime.parse('2022-07-21'), 'Qatar'),
  UserModel('Parvez', DateTime.parse('2022-06-09'), 'UAE'),
  UserModel('Kainat', DateTime.parse('2022-06-25'), 'England'),
  UserModel('Rimsha', DateTime.parse('2022-06-30'), 'Tajiskitan'),
  UserModel('Mary', DateTime.parse('2022-10-07'), 'Iran'),
  UserModel('Marlou', DateTime.parse('2022-10-11'), 'Iraq'),
  UserModel('Zohain', DateTime.parse('2022-12-20'), 'Iran'),
  UserModel('Shayan', DateTime.parse('2022-12-27'), 'Netherland'),
  UserModel('Rafay', DateTime.parse('2022-12-21'), 'Pakistan'),
]..sort((a, b) => a.date.compareTo(b.date));