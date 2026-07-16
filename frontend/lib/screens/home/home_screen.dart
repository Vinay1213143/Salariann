import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/jobs_provider.dart';
import '../../providers/companies_provider.dart';
import '../../widgets/job_card.dart';
import '../../widgets/filter_panel.dart';
import '../../widgets/responsive_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;
  String? _selectedJobType;
  int? _minSalary;
  int? _maxSalary;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    Future.microtask(() {
      context.read<JobsProvider>().fetchJobs();
      context.read<CompaniesProvider>().fetchCompanies();
    });
  }

  void _applyFilters() {
    final jobsProvider = context.read<JobsProvider>();
    jobsProvider.filterJobs(
      searchQuery: _searchController.text,
      city: _selectedCity,
      jobType: _selectedJobType,
      minSalary: _minSalary,
      maxSalary: _maxSalary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Salariann',
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchHeader(),
            _buildFilterSection(),
            _buildJobsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Your Perfect Job',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover IT jobs with real affordability insights',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              hintText: 'Search jobs, companies, roles...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FilterPanel(
        selectedCity: _selectedCity,
        selectedJobType: _selectedJobType,
        minSalary: _minSalary,
        maxSalary: _maxSalary,
        onCityChanged: (city) {
          setState(() => _selectedCity = city);
          _applyFilters();
        },
        onJobTypeChanged: (type) {
          setState(() => _selectedJobType = type);
          _applyFilters();
        },
        onSalaryRangeChanged: (min, max) {
          setState(() {
            _minSalary = min;
            _maxSalary = max;
          });
          _applyFilters();
        },
      ),
    );
  }

  Widget _buildJobsSection() {
    return Consumer<JobsProvider>(
      builder: (context, jobsProvider, _) {
        if (jobsProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          );
        }

        if (jobsProvider.filteredJobs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No jobs found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobsProvider.filteredJobs.length,
            itemBuilder: (context, index) {
              final job = jobsProvider.filteredJobs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: JobCard(
                  job: job,
                  onTap: () {},
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
