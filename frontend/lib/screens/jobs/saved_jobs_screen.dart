import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/auth_provider.dart';
import '../../models/job.dart';
import '../../theme/app_theme.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({Key? key}) : super(key: key);

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCity;
  String? _selectedCompany;
  int? _minSalary;
  int? _maxSalary;
  String _sortBy = 'date';
  List<Job> _savedJobs = [];
  List<Job> _filteredJobs = [];
  bool _isLoading = true;
  String? _error;
  Job? _comparisonJob;

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
    _loadSavedJobs();
  }

  void _loadSavedJobs() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _savedJobs = _generateMockSavedJobs();
        _applyFilters();
        _isLoading = false;
      });
    });
  }

  void _applyFilters() {
    _filteredJobs = _savedJobs.where((job) {
      final matchSearch = _searchController.text.isEmpty ||
          job.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          (job.company?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false);

      final matchCity = _selectedCity == null || job.city == _selectedCity;

      final matchCompany = _selectedCompany == null ||
          (job.company?.toLowerCase().contains(_selectedCompany!.toLowerCase()) ?? false);

      final jobSalaryMin = job.annualCtcMin ?? 0;
      final jobSalaryMax = job.annualCtcMax ?? 0;
      final matchSalary = (_minSalary == null || jobSalaryMax >= (_minSalary! * 100000)) &&
          (_maxSalary == null || jobSalaryMin <= (_maxSalary! * 100000));

      return matchSearch && matchCity && matchCompany && matchSalary;
    }).toList();

    _sortJobs();
    setState(() {});
  }

  void _sortJobs() {
    switch (_sortBy) {
      case 'salary_high':
        _filteredJobs.sort((a, b) => (b.annualCtcMax ?? 0).compareTo(a.annualCtcMax ?? 0));
        break;
      case 'salary_low':
        _filteredJobs.sort((a, b) => (a.annualCtcMin ?? 0).compareTo(b.annualCtcMin ?? 0));
        break;
      case 'company':
        _filteredJobs.sort((a, b) => (a.company ?? '').compareTo(b.company ?? ''));
        break;
      case 'date':
      default:
        _filteredJobs.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    }
  }

  void _removeSavedJob(String jobId) {
    setState(() {
      _savedJobs.removeWhere((job) => job.id == jobId);
      _applyFilters();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job removed from saved')),
    );
  }

  void _showComparisonModal(Job job) {
    showDialog(
      context: context,
      builder: (context) => _buildComparisonDialog(job),
    );
  }

  void _exportToCSV() {
    final csv = _generateCSV();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported ${_filteredJobs.length} jobs to CSV')),
    );
  }

  String _generateCSV() {
    final buffer = StringBuffer();
    buffer.writeln('Job Title,Company,City,Min Salary,Max Salary,Posted Date');
    for (final job in _filteredJobs) {
      buffer.writeln(
        '${job.title},${job.company ?? 'N/A'},${job.city},${job.annualCtcMin ?? 'N/A'},${job.annualCtcMax ?? 'N/A'},${job.postedAt.toIso8601String()}',
      );
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saved Jobs')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in to view saved jobs'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push('/login'),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportToCSV,
            tooltip: 'Export to CSV',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                  children: [
                    _buildSearchAndFilters(),
                    Expanded(
                      child: _filteredJobs.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredJobs.length,
                              itemBuilder: (context, index) {
                                final job = _filteredJobs[index];
                                return _buildSavedJobCard(job);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
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
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'City',
                  _selectedCity,
                  _cities,
                  (value) {
                    setState(() => _selectedCity = value);
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _buildSortDropdown(),
              ],
            ),
          ),
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

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _sortBy,
      onChanged: (value) {
        if (value != null) {
          setState(() => _sortBy = value);
          _applyFilters();
        }
      },
      items: const [
        DropdownMenuItem(value: 'date', child: Text('Newest First')),
        DropdownMenuItem(value: 'salary_high', child: Text('Highest Salary')),
        DropdownMenuItem(value: 'salary_low', child: Text('Lowest Salary')),
        DropdownMenuItem(value: 'company', child: Text('Company A-Z')),
      ],
    );
  }

  Widget _buildSavedJobCard(Job job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (job.companyLogo != null)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Image.network(
                      job.companyLogo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text((job.company ?? 'U')[0]),
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
                      color: AppTheme.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        (job.company ?? 'J')[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        job.company ?? 'Unknown Company',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            job.city,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (job.annualCtcMin != null && job.annualCtcMax != null)
              Text(
                '₹${(job.annualCtcMin! / 100000).toStringAsFixed(1)}L - ₹${(job.annualCtcMax! / 100000).toStringAsFixed(1)}L',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.visibility,
                  'View',
                  () => context.push('/jobs/${job.id}'),
                ),
                _buildActionButton(
                  Icons.open_in_new,
                  'Apply',
                  () async {
                    if (await canLaunchUrl(Uri.parse(job.atsUrl))) {
                      await launchUrl(Uri.parse(job.atsUrl));
                    }
                  },
                ),
                _buildActionButton(
                  Icons.compare,
                  'Compare',
                  () => _showComparisonModal(job),
                ),
                _buildActionButton(
                  Icons.share,
                  'Share',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job link copied to clipboard')),
                    );
                  },
                ),
                _buildActionButton(
                  Icons.delete,
                  'Remove',
                  () => _removeSavedJob(job.id),
                  isDestructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return Expanded(
      child: Tooltip(
        message: label,
        child: IconButton(
          icon: Icon(icon, size: 20),
          color: isDestructive ? Colors.red : AppTheme.primaryColor,
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No saved jobs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start saving jobs to view them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/home'),
            icon: const Icon(Icons.search),
            label: const Text('Browse Jobs'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonDialog(Job job) {
    return AlertDialog(
      title: const Text('Job Comparison'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a job to compare with:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _filteredJobs.length,
                itemBuilder: (context, index) {
                  final otherJob = _filteredJobs[index];
                  if (otherJob.id == job.id) return const SizedBox.shrink();
                  return ListTile(
                    title: Text(otherJob.title),
                    subtitle: Text(otherJob.company ?? 'Unknown'),
                    onTap: () {
                      Navigator.pop(context);
                      _showComparisonResult(job, otherJob);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _showComparisonResult(Job job1, Job job2) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Job Comparison'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildComparisonRow('Job Title', job1.title, job2.title),
              _buildComparisonRow('Company', job1.company ?? 'N/A', job2.company ?? 'N/A'),
              _buildComparisonRow('City', job1.city, job2.city),
              _buildComparisonRow(
                'Salary',
                '₹${(job1.annualCtcMin ?? 0) / 100000}L - ₹${(job1.annualCtcMax ?? 0) / 100000}L',
                '₹${(job2.annualCtcMin ?? 0) / 100000}L - ₹${(job2.annualCtcMax ?? 0) / 100000}L',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value1,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Job> _generateMockSavedJobs() {
    return [
      Job(
        id: '1',
        title: 'Senior Software Engineer',
        description: 'Looking for experienced software engineer',
        city: 'Bangalore',
        annualCtcMin: 1200000,
        annualCtcMax: 1800000,
        techStack: ['Java', 'Spring Boot', 'Microservices'],
        atsUrl: 'https://example.com/apply/1',
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        isActive: true,
        companyId: '1',
        company: 'TCS',
      ),
      Job(
        id: '2',
        title: 'Full Stack Developer',
        description: 'Develop and maintain web applications',
        city: 'Hyderabad',
        annualCtcMin: 900000,
        annualCtcMax: 1400000,
        techStack: ['React', 'Node.js', 'MongoDB'],
        atsUrl: 'https://example.com/apply/2',
        postedAt: DateTime.now().subtract(const Duration(days: 5)),
        isActive: true,
        companyId: '2',
        company: 'Infosys',
      ),
      Job(
        id: '3',
        title: 'DevOps Engineer',
        description: 'Manage cloud infrastructure',
        city: 'Bangalore',
        annualCtcMin: 1100000,
        annualCtcMax: 1600000,
        techStack: ['AWS', 'Docker', 'Kubernetes'],
        atsUrl: 'https://example.com/apply/3',
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        isActive: true,
        companyId: '3',
        company: 'Wipro',
      ),
    ];
  }
}
