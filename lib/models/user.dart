class CustomUser {
  final String uid;

  CustomUser({required this.uid});
}

class UserData {
  final String uid;
  final String? name;
  final String? sugar;
  final int? strength;
  final String? avatarUrl;
  final bool? isDarkMode;
  final bool onboardingCompleted;

  UserData({
    required this.uid,
    this.name,
    this.sugar,
    this.strength,
    this.avatarUrl,
    this.isDarkMode,
    this.onboardingCompleted = false,
  });
}
