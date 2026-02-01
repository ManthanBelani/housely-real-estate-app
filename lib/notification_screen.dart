import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock data for notifications
  final List<NotificationItem> notifications = [
    // Today
    NotificationItem(
      type: NotificationType.system,
      title: 'Congratulations, your listing is now active. ',
      subtitle: 'click here to see your listing',
      time: 'just now',
      hasUnread: true,
    ),
    NotificationItem(
      type: NotificationType.system,
      title: 'Welcome, Don\'t forget to complete your personal info',
      time: '2 hours ago',
      hasUnread: false,
    ),
    // Yesterday
    NotificationItem(
      type: NotificationType.message,
      title: 'Anggela and joni send you message, check it now',
      time: 'yesterday',
      hasUnread: true,
      senderImage: 'assets/images/Ellipse16.png',
    ),
    NotificationItem(
      type: NotificationType.system,
      title: 'Welcome, Don\'t forget to complete your personal info',
      time: 'yesterday',
      hasUnread: false,
    ),
    NotificationItem(
      type: NotificationType.system,
      title: 'Welcome, Don\'t forget to complete your personal info',
      time: 'yesterday',
      hasUnread: false,
    ),
    NotificationItem(
      type: NotificationType.message,
      title: 'Jhon, ani & 2 other send you message, check it now',
      time: 'yesterday',
      hasUnread: true,
      senderImage: 'assets/images/Ellipse16.png',
    ),
    NotificationItem(
      type: NotificationType.system,
      title: 'Welcome, Don\'t forget to complete your personal info',
      time: 'yesterday',
      hasUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Notification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ..._buildNotificationsForSection('Today'),

                SizedBox(height: 30),
                Text(
                  'Yesterday',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ..._buildNotificationsForSection('Yesterday'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationsForSection(String section) {
    final List<Widget> items = [];

    for (var notification in notifications) {
      if ((section == 'Today' && notification.time == 'just now') ||
          (section == 'Yesterday' && notification.time == 'yesterday')) {
        items.add(
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: notification.hasUnread
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontWeight: notification.hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (notification.subtitle != null)
                              TextSpan(
                                text: notification.subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.time,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        if (items.length <
            notifications
                .where(
                  (n) =>
                      (section == 'Today' && n.time == 'just now') ||
                      (section == 'Yesterday' && n.time == 'yesterday'),
                )
                .length) {
          // items.add(Divider(height: 1, color: Colors.grey[200]));
        }
      }
    }

    return items;
  }

  Widget _buildNotificationIcon(NotificationItem notification) {
    if (notification.type == NotificationType.message) {
      if (notification.senderImage != null) {
        return CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(notification.senderImage!),
        );
      } else {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF9F5FF),
          ),
          child: Image.asset('assets/images/Notification.png'),
        );
      }
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF9F5FF),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Icon(Icons.circle, color: Colors.purple, size: 10),
            if (notification.hasUnread)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      );
    }
  }
}

enum NotificationType { system, message }

class NotificationItem {
  final NotificationType type;
  final String title;
  final String? subtitle;
  final String time;
  final bool hasUnread;
  final String? senderImage;

  NotificationItem({
    required this.type,
    required this.title,
    this.subtitle,
    required this.time,
    required this.hasUnread,
    this.senderImage,
  });
}
