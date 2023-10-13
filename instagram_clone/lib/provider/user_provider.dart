import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  AuthMethds _authMethds = AuthMethds();

  User get getUser => _user!;

  Future<void> refreshuser() async {
    User user = await _authMethds.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
