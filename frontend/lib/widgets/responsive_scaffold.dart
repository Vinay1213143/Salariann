import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<NavigationDestination>? navigationDestinations;
  final int selectedIndex;
  final ValueChanged<int>? onNavigationChanged;
  final Widget? rightPanel;

  const ResponsiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.navigationDestinations,
    this.selectedIndex = 0,
    this.onNavigationChanged,
    this.rightPanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        final isDesktop = constraints.maxWidth >= 1024;

        if (isMobile) {
          return _buildMobileLayout();
        } else if (isTablet) {
          return _buildTabletLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: navigationDestinations != null
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onNavigationChanged ?? (_) {},
              destinations: navigationDestinations!,
            )
          : null,
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: Row(
        children: [
          if (navigationDestinations != null)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onNavigationChanged ?? (_) {},
              destinations: navigationDestinations!
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: dest.icon,
                      label: Text(dest.label),
                    ),
                  )
                  .toList(),
            ),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: Row(
        children: [
          if (navigationDestinations != null)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onNavigationChanged ?? (_) {},
              destinations: navigationDestinations!
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: dest.icon,
                      label: Text(dest.label),
                    ),
                  )
                  .toList(),
            ),
          Expanded(
            flex: 2,
            child: body,
          ),
          if (rightPanel != null)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: rightPanel,
              ),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
