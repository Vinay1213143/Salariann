import 'package:flutter/material.dart';
import '../../widgets/linkedin_shell.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedNavIndex = 4;

  @override
  Widget build(BuildContext context) {
    return LinkedInShell(
      initialNavIndex: _selectedNavIndex,
      onNavChanged: (index) {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Notifications',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Notifications list
          ...[
            _buildNotificationCard(
              context,
              'Job Application Update',
              'Your application for Frontend Developer at Accenture has been viewed',
              Icons.work,
              '2 hours ago',
            ),
            _buildNotificationCard(
              context,
              'New Job Match',
              'A new Senior Software Engineer role matches your profile',
              Icons.notifications_active,
              '5 hours ago',
            ),
            _buildNotificationCard(
              context,
              'Profile View',
              'TCS Recruiter viewed your profile',
              Icons.person,
              '1 day ago',
            ),
            _buildNotificationCard(
              context,
              'Interview Invitation',
              'Capgemini invited you to interview for a role',
              Icons.event,
              '2 days ago',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    String title,
    String message,
    IconData icon,
    String time,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.linkedinTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.linkedinTextSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
