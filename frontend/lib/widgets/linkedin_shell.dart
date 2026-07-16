import 'package:flutter/material.dart';
import 'linkedin_header.dart';
import '../theme/app_theme.dart';

class LinkedInShell extends StatefulWidget {
  final Widget body;
  final Widget? rightPanel;
  final int initialNavIndex;
  final ValueChanged<int>? onNavChanged;

  const LinkedInShell({
    Key? key,
    required this.body,
    this.rightPanel,
    this.initialNavIndex = 0,
    this.onNavChanged,
  }) : super(key: key);

  @override
  State<LinkedInShell> createState() => _LinkedInShellState();
}

class _LinkedInShellState extends State<LinkedInShell> {
  late int _selectedNavIndex;

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialNavIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: AppTheme.linkedinBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: LinkedInHeader(
          selectedIndex: _selectedNavIndex,
          onNavChanged: (index) {
            setState(() {
              _selectedNavIndex = index;
            });
            widget.onNavChanged?.call(index);
          },
        ),
      ),
      body: isMobile
          ? _buildMobileLayout()
          : isTablet
              ? _buildTabletLayout()
              : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: widget.body,
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: widget.body,
            ),
          ),
        ),
        if (widget.rightPanel != null)
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppTheme.linkedinBorder, width: 1),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: widget.rightPanel,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar (optional, can be used for filters)
        SizedBox(
          width: 225,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildLeftSidebar(),
            ),
          ),
        ),
        // Main content
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: widget.body,
                ),
              ),
            ),
          ),
        ),
        // Right sidebar
        if (widget.rightPanel != null)
          SizedBox(
            width: 300,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppTheme.linkedinBorder, width: 1),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: widget.rightPanel,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLeftSidebar() {
    return Column(
      children: [
        // Placeholder for left sidebar content
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Salariann',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover IT jobs with real salary insights',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.linkedinTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
