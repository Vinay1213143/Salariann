import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class LinkedInHeader extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavChanged;

  const LinkedInHeader({
    Key? key,
    required this.selectedIndex,
    required this.onNavChanged,
  }) : super(key: key);

  @override
  State<LinkedInHeader> createState() => _LinkedInHeaderState();
}

class _LinkedInHeaderState extends State<LinkedInHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.linkedinBorder, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 24,
          vertical: 8,
        ),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => context.go('/'),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'SL',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Salariann',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),

            // Search bar (hidden on mobile)
            if (!isMobile)
              Expanded(
                flex: 1,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.linkedinBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: AppTheme.linkedinTextSecondary),
                      prefixIcon: Icon(Icons.search, size: 18, color: AppTheme.linkedinTextSecondary),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

            const SizedBox(width: 24),

            // Navigation items
            if (!isMobile) ...[
              _buildNavItem(context, 0, Icons.home, 'Home'),
              _buildNavItem(context, 1, Icons.people, 'Network'),
              _buildNavItem(context, 2, Icons.work, 'Jobs'),
              _buildNavItem(context, 3, Icons.mail, 'Messaging'),
              _buildNavItem(context, 4, Icons.notifications, 'Notifications'),
              _buildNavItem(context, 5, Icons.person, 'Me'),
            ] else
              // Mobile: hamburger menu
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Show mobile menu
                  _showMobileMenu(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isActive = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () {
        widget.onNavChanged(index);
        _navigateToPage(context, index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppTheme.linkedinText : AppTheme.linkedinTextSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppTheme.linkedinText : AppTheme.linkedinTextSecondary,
              ),
            ),
            if (isActive)
              Container(
                width: 35,
                height: 2,
                margin: const EdgeInsets.only(top: 2),
                color: AppTheme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/companies');
        break;
      case 2:
        context.go('/jobs');
        break;
      case 3:
        context.go('/messaging');
        break;
      case 4:
        context.go('/notifications');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMobileMenuItem(context, 0, Icons.home, 'Home'),
            _buildMobileMenuItem(context, 1, Icons.people, 'Network'),
            _buildMobileMenuItem(context, 2, Icons.work, 'Jobs'),
            _buildMobileMenuItem(context, 3, Icons.mail, 'Messaging'),
            _buildMobileMenuItem(context, 4, Icons.notifications, 'Notifications'),
            _buildMobileMenuItem(context, 5, Icons.person, 'Me'),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        widget.onNavChanged(index);
        _navigateToPage(context, index);
      },
    );
  }
}
