import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  String title;
  String message;
  String time;
  bool isUnread;
  final IconData icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isUnread = false,
    required this.icon,
  });
}

class NotificationProvider with ChangeNotifier {
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  void addNotification(String title, String message) {
    _notifications.insert(
      0,
      NotificationItem(
        id: DateTime.now().toString(),
        title: title,
        message: message,
        time: "Just Now",
        isUnread: true,
        icon: Icons.notifications_active,
      ),
    );
    notifyListeners();
  }

  void updateNotification(String id, String title, String message) {
    int index = _notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      _notifications[index].title = title;
      _notifications[index].message = message;
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void markAsRead(String id) {
    int index = _notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      _notifications[index].isUnread = false;
      notifyListeners();
    }
  }
}
