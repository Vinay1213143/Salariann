import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/companies_provider.dart';
import '../../widgets/responsive_scaffold.dart';

class CompanyDirectoryScreen extends StatefulWidget {
  const CompanyDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<CompanyDirectoryScreen> createState() => _CompanyDirectoryScreenState();
}

class _CompanyDirectoryScreenState extends State<CompanyDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  void _loadCompanies() {
    final companiesProvider = context.read<CompaniesProvider>();
    companiesProvider.fetchCompanies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companiesProvider = context.watch<CompaniesProvider>();

    return ResponsiveScaffold(
      title: 'Companies',
      selectedIndex: _selectedNavIndex,
      onNavigationChanged: (index) {
        setState(() {
          _selectedNavIndex = index;
        });
        _handleNavigation(index);
      },
      navigationDestinations: [
        const NavigationDestination(
          icon: Icon(Icons.work),
          label: 'Jobs',
        ),
        const NavigationDestination(
          icon: Icon(Icons.business),
          label: 'Companies',
        ),
        const NavigationDestination(
          icon: Icon(Icons.rate_review),
          label: 'Contribute',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search companies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                final companiesProvider = context.read<CompaniesProvider>();
                companiesProvider.fetchCompanies(search: value);
              },
            ),
          ),
          Expanded(
            child: companiesProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : companiesProvider.error != null
                    ? Center(
                        child: Text('Error: ${companiesProvider.error}'),
                      )
                    : companiesProvider.companies.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.business_center,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No companies found',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: companiesProvider.companies.length,
                            itemBuilder: (context, index) {
                              final company = companiesProvider.companies[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: InkWell(
                                  onTap: () {
                                    context.push('/companies/${company.id}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        if (company.logoUrl != null)
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.grey[200],
                                            ),
                                            child: Image.network(
                                              company.logoUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Center(
                                                  child: Text(
                                                    company.name[0].toUpperCase(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        else
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.grey[200],
                                            ),
                                            child: Center(
                                              child: Text(
                                                company.name[0].toUpperCase(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                company.name,
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                              const SizedBox(height: 4),
                                              if (company.city != null)
                                                Row(
                                                  children: [
                                                    Icon(Icons.location_on_outlined,
                                                        size: 14, color: Colors.grey[600]),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      company.city!,
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                            color: Colors.grey[600],
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              if (company.employeeCount != null)
                                                Text(
                                                  '${company.employeeCount} employees',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: Colors.grey[600],
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward, color: Colors.grey[400]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        context.go('/jobs');
        break;
      case 1:
        break;
      case 2:
        context.go('/contribute/review');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
