import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/live_jobs_provider.dart';
import '../../theme/app_theme.dart';

class LiveJobsScreen extends StatefulWidget {
  const LiveJobsScreen({Key? key}) : super(key: key);

  @override
  State<LiveJobsScreen> createState() => _LiveJobsScreenState();
}

class _LiveJobsScreenState extends State<LiveJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSource = 'all';

  static const _sourceOptions = {
    'all': 'All Sources',
    'remoteok': 'RemoteOK',
    'remotive': 'Remotive',
    'adzuna': 'Adzuna',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveJobsProvider>().fetchLiveJobs(
            sources: 'remoteok,remotive,adzuna',
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final sources = _selectedSource == 'all'
        ? 'remoteok,remotive,adzuna'
        : _selectedSource;
    context.read<LiveJobsProvider>().fetchLiveJobs(
          query: _searchController.text,
          sources: sources,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.public, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Text('Live Market Jobs'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSourceChips(),
          Expanded(child: _buildJobsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search live jobs (e.g. React, Python, DevOps)...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _search,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceChips() {
    return Consumer<LiveJobsProvider>(
      builder: (context, provider, _) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                children: _sourceOptions.entries.map((entry) {
                  final isSelected = _selectedSource == entry.key;
                  return ChoiceChip(
                    label: Text(entry.value, style: TextStyle(fontSize: 13)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedSource = entry.key);
                      _search();
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              if (provider.sourceStats.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Found ${provider.total} jobs from: ${provider.sourceStats.entries.map((e) => '${e.key} (${e.value})').join(', ')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobsList() {
    return Consumer<LiveJobsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                Text('Fetching live jobs from multiple sources...', style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text('Error: ${provider.error}', style: TextStyle(color: Colors.red.shade600)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _search, child: const Text('Retry')),
              ],
            ),
          );
        }

        if (provider.jobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('No live jobs found', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text('Try a different search query', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.jobs.length,
          itemBuilder: (context, index) => _buildLiveJobCard(provider.jobs[index]),
        );
      },
    );
  }

  Widget _buildLiveJobCard(LiveJob job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
        border: Border(left: BorderSide(color: _sourceColor(job.source), width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (job.companyLogo != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    job.companyLogo!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _companyInitial(job.company),
                  ),
                )
              else
                _companyInitial(job.company),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                    const SizedBox(height: 2),
                    Text(job.company, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 3),
                        Flexible(child: Text(job.city, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis)),
                        if (job.isRemote) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                            child: Text('Remote', style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _buildSourceBadge(job.source),
            ],
          ),
          // Description
          if (job.description != null && job.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              job.description!.length > 200 ? '${job.description!.substring(0, 200)}...' : job.description!,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
            ),
          ],
          // Tech stack
          if (job.techStack.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: job.techStack.take(6).map((tech) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(tech, style: TextStyle(fontSize: 11, color: AppTheme.primaryColor, fontWeight: FontWeight.w500)),
                  )).toList(),
            ),
          ],
          // Salary & type
          const SizedBox(height: 10),
          Row(
            children: [
              if (job.salaryMin != null || job.salaryMax != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    _formatSalary(job),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                  ),
                ),
              if (job.employmentType != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
                  child: Text(job.employmentType!, style: TextStyle(fontSize: 12, color: Colors.blue.shade700)),
                ),
              ],
            ],
          ),
          // Apply button
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (job.applyLink != null)
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(job.applyLink!),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Apply Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _companyInitial(String name) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(colors: [AppTheme.primaryColor, const Color(0xFF084FA0)]),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSourceBadge(String source) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _sourceColor(source).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        source,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _sourceColor(source)),
      ),
    );
  }

  Color _sourceColor(String source) {
    switch (source) {
      case 'remoteok':
        return Colors.red.shade600;
      case 'remotive':
        return Colors.purple.shade600;
      case 'adzuna':
        return Colors.teal.shade600;
      case 'jsearch':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _formatSalary(LiveJob job) {
    if (job.salaryMin != null && job.salaryMax != null) {
      return '\$${_shortNum(job.salaryMin!)} - \$${_shortNum(job.salaryMax!)}';
    }
    if (job.salaryMax != null) return 'Up to \$${_shortNum(job.salaryMax!)}';
    if (job.salaryMin != null) return 'From \$${_shortNum(job.salaryMin!)}';
    return 'Salary N/A';
  }

  String _shortNum(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toStringAsFixed(0);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
