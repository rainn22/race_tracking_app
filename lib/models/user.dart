enum Role {
  manager('Race Manager'),
  tracker('Time Tracker');

  final String label;
  
  const Role(this.label);
}

class User {
  final Role role;

  User({required this.role});
}