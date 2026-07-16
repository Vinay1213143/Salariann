import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/indian_companies_provider.dart';
import '../../models/job.dart';
import '../../widgets/responsive_scaffold.dart';

class IndiaCompaniesScreen extends StatefulWidget {
  const IndiaCompaniesScreen({Key? key}) : super(key: key);

  @override
  State<IndiaCompaniesScreen> createState() => _IndiaCompaniesScreenState();
}

class _IndiaCompaniesScreenState extends State<IndiaCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  void _loadCompanies() {
    final provider = context.read<IndianCompaniesProvider>();
    provider.fetchIndianCompanies();
    provider.fetchIndianCities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'India IT Companies',
      body: Consumer<IndianCompaniesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.indianCompanies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.indianCompanies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCompanies,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildFilters(provider),
                if (provider.indianCompanies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('No companies found'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.indianCompanies.length,
                    itemBuilder: (context, index) {
                      final company = provider.indianCompanies[index];
                      return _buildCompanyCard(company);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          final provider = context.read<IndianCompaniesProvider>();
          provider.searchCompanies(value);
        },
        decoration: InputDecoration(
          hintText: 'Search companies...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(IndianCompaniesProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            PopupMenuButton<String>(
              onSelected: (city) {
                setState(() => _selectedCity = city);
                provider.fetchIndianCompaniesByCity(city);
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: '',
                    child: Text('All Cities'),
                  ),
                  ...provider.indianCities.map((city) {
                    return PopupMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                ];
              },
              child: Chip(
                label: Text(_selectedCity ?? 'City'),
                onDeleted: _selectedCity != null
                    ? () {
                        setState(() => _selectedCity = null);
                        provider.fetchIndianCompanies();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(Company company) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (company.logoUrl != null)
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: NetworkImage(company.logoUrl!),
                  )
                else
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.business,
                      size: 32,
                      color: Colors.blue.shade700,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${company.employeeCount ?? 0} employees',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (company.city != null)
                        Text(
                          company.city!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (company.description != null)
              Text(
                company.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 12),
            if (company.rating != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${company.rating} (${company.totalReviews ?? 0} reviews)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/companies/${company.id}');
                    },
                    child: const Text('View Profile'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/companies/${company.id}');
                    },
                    child: const Text('View Jobs'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
