import 'dart:convert';

class UserActions {
  String action;
  String toDevice;
  UserActions({required this.action, required this.toDevice});

  factory UserActions.fromJson(Map<String, dynamic> jsonData) {
    return UserActions(
        action: jsonData['action'], toDevice: jsonData['toDevice']);
  }

  static Map<String, dynamic> toMap(UserActions action) =>
      {'action': action.action, 'toDevice': action.toDevice};

  static String encode(List<UserActions> actions) => json.encode(
        actions
            .map<Map<String, dynamic>>((action) => UserActions.toMap(action))
            .toList(),
      );

  static List<UserActions> decode(String actions) =>
      (json.decode(actions) as List<dynamic>)
          .map<UserActions>((item) => UserActions.fromJson(item))
          .toList();
}
