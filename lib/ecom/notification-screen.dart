import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample data for notifications
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Order Placed',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
    ),
    NotificationItem(
      title: 'Offer: 50% off on Electronics',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    NotificationItem(
      title: 'Your item has been shipped',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationItem(
      title: 'New Product Added: Smartwatch',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
  ];

  // Global key for the AnimatedList to control animations
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Function to mark all notifications as read
  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Future.delayed(const Duration(milliseconds: 100));
      for (int i = 0; i < notifications.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    });
    // Triggering the animations for the items when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        // backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Read All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: 0,
          itemBuilder: (context, index, animation) {
            final notification = notifications[index];
            return FadeTransition(opacity: animation, child: _buildNotificationCard(notification, animation, index));
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, Animation<double> animation, int index) {
    // Add fade and slide animation to each notification
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5), // Slide from below
              end: Offset.zero, // Slide to its original position
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // color: (notification.isRead && Get.theme == ThemeData.dark())
        //     ? Colors.b
        //     : Colors.blue[50], // Highlight unread notifications
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            notification.isRead ? Icons.notifications_none : Icons.notifications_active,
            color: notification.isRead ? Colors.grey : Colors.blue,
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              //  color: notification.isRead ? Colors.black : Colors.blue,
            ),
          ),
          subtitle: Text(
            _formatTime(notification.time),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour ago';
    } else {
      return '${difference.inDays} day ago';
    }
  }
}

class NotificationItem {
  final String title;
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.time,
    this.isRead = false,
  });
}
