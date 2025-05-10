import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  Role _currentRole = Role.manager;

  Role getCurrentRole() => _currentRole;

  void switchRole(Role role) {
    _currentRole = role;
    notifyListeners();
  }
}
