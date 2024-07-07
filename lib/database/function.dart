import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'model.dart';

ValueNotifier<List<User>> UserList = ValueNotifier([]);

Future<void> addUserList(User value) async
{
  final UserDB = await Hive.openBox<User>("UserDB");
  final key = await UserDB.add(value);
  value.id = key;
  await value.save();
  UserList.value.add(value);
  UserList.notifyListeners();

}

Future<void> getUserList() async
{
  final UserDB = await Hive.openBox<User>("UserDB");
  UserList.value.clear();
  UserList.value.addAll(UserDB.values);
  UserList.notifyListeners();
}

Future<void> deleteUserList(int id) async
{
  final UserDB = await Hive.openBox<User>("UserDB");
  UserDB.delete(id);
  getUserList();
}
Future<void> clearAllUsers() async {
  final UserDB = await Hive.openBox<User>("UserDB");
  await UserDB.clear();
  UserList.value.clear();
  UserList.notifyListeners();
}
