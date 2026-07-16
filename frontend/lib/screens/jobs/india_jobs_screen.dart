import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/indian_jobs_provider.dart';
import '../../models/job.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../widgets/job_card.dart';

class IndiaJobsScreen extends StatefulWidget {
  const IndiaJobsScreen({Key? key}) : super(key: key);

  @override
  State<IndiaJobsScreen> createState() => _IndiaJobsScreenState();
}

class _IndiaJobsScreenState extends State<IndiaJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;
  String? _selectedCompany;
  int? _minSalary;
  int? _maxSalary;

  final List<String> _indianCities = [
    'Bangalore', 'Mumbai', 'Pune', 'Hyderabad', 'Delhi',
    'Chennai', 'Kolkata', 'Noida', 'Gurgaon', 'Ahmedabad',
    'Jaipur', 'Chandigarh', 'Kochi', 'Indore', 'Lucknow'
  ];

  @override
  void initState() {
    super.initState();
    _loadIndianJobs();
  }

  void _loadIndianJobs() {
    final provider = context.read<IndianJobsProvider>();
    provider.fetchIndianJobs();
  }

  void _applyFilters() {
    final provider = context.read<IndianJobsProvider>();
    provider.filterIndianJobs(
      searchQuery: _searchController.text,
      city: _selectedCity,
      company: _selectedCompany,
      minSalary: _minSalary,
      maxSalary: _maxSalary,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'India IT Jobs',
      body: Consumer<IndianJobsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.indianJobs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.indianJobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadIndianJobs,
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
                if (provider.filteredIndianJobs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('No jobs found'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.filteredIndianJobs.length,
                    itemBuilder: (context, index) {
                      final job = provider.filteredIndianJobs[index];
                      return JobCard(
                        job: job,
                        onTap: () {
                          context.push('/jobs/${job.id}');
                        },
                      );
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
        onChanged: (_) => _applyFilters(),
        decoration: InputDecoration(
          hintText: 'Search jobs, companies...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(IndianJobsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'City',
                  _selectedCity,
                  _indianCities,
                  (value) {
                    setState(() => _selectedCity = value);
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _buildSalaryRangeFilter(),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String? selected,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: null,
            child: Text('All'),
          ),
          ...options.map((option) {
            return PopupMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ];
      },
      child: Chip(
        label: Text(selected ?? label),
        onDeleted: selected != null ? () => onChanged(null) : null,
      ),
    );
  }

  Widget _buildSalaryRangeFilter() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'all',
            child: const Text('All Salaries'),
            onTap: () {
              setState(() {
                _minSalary = null;
                _maxSalary = null;
              });
              _applyFilters();
            },
          ),
          PopupMenuItem<String>(
            value: '0-5',
            child: const Text('0-5 LPA'),
            onTap: () {
              setState(() {
                _minSalary = 0;
                _maxSalary = 5;
              });
              _applyFilters();
            },
          ),
          PopupMenuItem<String>(
            value: '5-10',
            child: const Text('5-10 LPA'),
            onTap: () {
              setState(() {
                _minSalary = 5;
                _maxSalary = 10;
              });
              _applyFilters();
            },
          ),
          PopupMenuItem<String>(
            value: '10-20',
            child: const Text('10-20 LPA'),
            onTap: () {
              setState(() {
                _minSalary = 10;
                _maxSalary = 20;
              });
              _applyFilters();
            },
          ),
          PopupMenuItem<String>(
            value: '20+',
            child: const Text('20+ LPA'),
            onTap: () {
              setState(() {
                _minSalary = 20;
                _maxSalary = null;
              });
              _applyFilters();
            },
          ),
        ];
      },
      child: Chip(
        label: Text(
          _minSalary != null
              ? '₹${_minSalary}-${_maxSalary ?? '∞'} LPA'
              : 'Salary',
        ),
        onDeleted: _minSalary != null
            ? () {
                setState(() {
                  _minSalary = null;
                  _maxSalary = null;
                });
                _applyFilters();
              }
            : null,
      ),
    );
  }
}
