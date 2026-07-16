import 'package:flutter/material.dart';
import '../../widgets/linkedin_shell.dart';
import '../../theme/app_theme.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({Key? key}) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  int _selectedNavIndex = 3;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Messaging',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search conversations...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Conversations list
          ...[
            _buildConversationCard(
              context,
              'Accenture Recruiter',
              'Thanks for your interest in our Frontend Developer role...',
              '2 hours ago',
            ),
            _buildConversationCard(
              context,
              'TCS HR',
              'We would like to schedule an interview with you...',
              '1 day ago',
            ),
            _buildConversationCard(
              context,
              'Capgemini Team',
              'Your application has been reviewed...',
              '3 days ago',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConversationCard(
    BuildContext context,
    String name,
    String message,
    String time,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            name[0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppTheme.linkedinTextSecondary),
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.linkedinTextSecondary,
          ),
        ),
      ),
    );
  }
}
