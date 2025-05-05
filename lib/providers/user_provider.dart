import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  Role _currentRole = Role.manager;
  final List<User> _timeTrackers = [];

  Role getCurrentRole() => _currentRole;

  void switchRole(Role role) {
    _currentRole = role;
    notifyListeners();
  }

  List<User> getTimeTrackers() => _timeTrackers;

  void addTimeTracker(User user) {
    if (user.role == Role.tracker && !_timeTrackers.contains(user)) {
      _timeTrackers.add(user);
      notifyListeners();
    }
  }

  void removeTimeTracker(User user) {
    if (_timeTrackers.remove(user)) {
      notifyListeners();
    }
  }

  void clearTrackers() {
    _timeTrackers.clear();
    notifyListeners();
  }
}
