import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/companies_provider.dart';
import '../../models/job.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String companyId;

  const CompanyProfileScreen({
    Key? key,
    required this.companyId,
  }) : super(key: key);

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadCompanyDetails();
  }

  void _loadCompanyDetails() {
    final companiesProvider = context.read<CompaniesProvider>();
    companiesProvider.fetchCompanyById(widget.companyId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companiesProvider = context.watch<CompaniesProvider>();
    final company = companiesProvider.selectedCompany;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: companiesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : companiesProvider.error != null
              ? Center(child: Text('Error: ${companiesProvider.error}'))
              : company == null
                  ? const Center(child: Text('Company not found'))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.grey[50],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (company.logoUrl != null)
                                      Container(
                                        width: 80,
                                        height: 80,
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
                                                  fontSize: 32,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            company.name,
                                            style: Theme.of(context).textTheme.headlineSmall,
                                          ),
                                          const SizedBox(height: 8),
                                          if (company.city != null)
                                            Row(
                                              children: [
                                                Icon(Icons.location_on_outlined,
                                                    size: 16, color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(company.city!),
                                              ],
                                            ),
                                          if (company.employeeCount != null)
                                            Text('${company.employeeCount} employees'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (company.description != null) ...[
                                  const SizedBox(height: 16),
                                  Text(
                                    company.description!,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Overview'),
                              Tab(text: 'Jobs'),
                              Tab(text: 'Reviews'),
                              Tab(text: 'Salaries'),
                              Tab(text: 'Interviews'),
                            ],
                          ),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildOverviewTab(context, company),
                                _buildJobsTab(context, company),
                                _buildReviewsTab(context, company),
                                _buildSalariesTab(context, company),
                                _buildInterviewsTab(context, company),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, Company company) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(context, 'Active Jobs', '${company.stats?['jobCount'] ?? 0}'),
          const SizedBox(height: 12),
          _buildStatCard(context, 'Reviews', '${company.stats?['reviewCount'] ?? 0}'),
          const SizedBox(height: 12),
          _buildStatCard(context, 'Salary Data', '${company.stats?['salaryDataCount'] ?? 0}'),
          const SizedBox(height: 12),
          _buildStatCard(context, 'Interview Experiences', '${company.stats?['interviewCount'] ?? 0}'),
          if (company.stats?['avgRating'] != null) ...[
            const SizedBox(height: 12),
            _buildStatCard(context, 'Average Rating', '${company.stats?['avgRating']} / 5'),
          ],
        ],
      ),
    );
  }

  Widget _buildJobsTab(BuildContext context, Company company) {
    final jobs = company.jobs ?? [];
    if (jobs.isEmpty) {
      return Center(
        child: Text(
          'No active jobs',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return ListTile(
          title: Text(job['title'] ?? 'Unknown'),
          subtitle: Text(job['city'] ?? 'Unknown'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () => context.push('/jobs/${job['id']}'),
        );
      },
    );
  }

  Widget _buildReviewsTab(BuildContext context, Company company) {
    final reviews = company.reviews ?? [];
    if (reviews.isEmpty) {
      return Center(
        child: Text(
          'No reviews yet',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ListTile(
          title: Text('Rating: ${review['overall_rating']}'),
          subtitle: Text(review['pros'] ?? 'No details'),
        );
      },
    );
  }

  Widget _buildSalariesTab(BuildContext context, Company company) {
    final salaries = company.salaries ?? [];
    if (salaries.isEmpty) {
      return Center(
        child: Text(
          'No salary data',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: salaries.length,
      itemBuilder: (context, index) {
        final salary = salaries[index];
        return ListTile(
          title: Text(salary['role'] ?? 'Unknown Role'),
          subtitle: Text('₹${salary['annual_ctc']}'),
        );
      },
    );
  }

  Widget _buildInterviewsTab(BuildContext context, Company company) {
    final interviews = company.interviews ?? [];
    if (interviews.isEmpty) {
      return Center(
        child: Text(
          'No interview experiences',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: interviews.length,
      itemBuilder: (context, index) {
        final interview = interviews[index];
        return ListTile(
          title: Text(interview['role'] ?? 'Unknown Role'),
          subtitle: Text('Difficulty: ${interview['difficulty']}/5'),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
