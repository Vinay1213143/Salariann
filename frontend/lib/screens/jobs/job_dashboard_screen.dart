import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/jobs_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/linkedin_shell.dart';
import '../../widgets/job_card.dart';
import '../../theme/app_theme.dart';

class JobDashboardScreen extends StatefulWidget {
  const JobDashboardScreen({Key? key}) : super(key: key);

  @override
  State<JobDashboardScreen> createState() => _JobDashboardScreenState();
}

class _JobDashboardScreenState extends State<JobDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;
  int _selectedNavIndex = 0;

  final List<String> _cities = [
    'Bangalore',
    'Hyderabad',
    'Pune',
    'Mumbai',
    'Delhi',
    'Gurgaon',
    'Noida',
    'Chennai',
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    final jobsProvider = context.read<JobsProvider>();
    jobsProvider.fetchJobs(city: _selectedCity);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<JobsProvider>();
    final authProvider = context.watch<AuthProvider>();

    return LinkedInShell(
      initialNavIndex: 2,
      onNavChanged: (index) {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (value) {
                    _loadJobs();
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      FilterChip(
                        label: const Text('All Cities'),
                        selected: _selectedCity == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCity = null;
                          });
                          _loadJobs();
                        },
                      ),
                      const SizedBox(width: 8),
                      ..._cities.map((city) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(city),
                            selected: _selectedCity == city,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCity = selected ? city : null;
                              });
                              _loadJobs();
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: jobsProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : jobsProvider.error != null
                    ? Center(
                        child: Text('Error: ${jobsProvider.error}'),
                      )
                    : jobsProvider.jobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No jobs found',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: jobsProvider.jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobsProvider.jobs[index];
                              return JobCard(
                                job: job,
                                onTap: () {
                                  context.push('/jobs/${job.id}');
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

}
