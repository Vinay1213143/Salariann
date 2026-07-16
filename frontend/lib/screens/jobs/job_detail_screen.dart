import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/jobs_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/job.dart';
import '../../widgets/suitability_badge.dart';
import '../../widgets/affordability_badge.dart';
import '../../theme/app_theme.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  const JobDetailScreen({
    Key? key,
    required this.jobId,
  }) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  void _loadJobDetails() {
    final jobsProvider = context.read<JobsProvider>();
    jobsProvider.fetchJobById(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<JobsProvider>();
    final authProvider = context.watch<AuthProvider>();
    final job = jobsProvider.selectedJob;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: jobsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobsProvider.error != null
              ? Center(child: Text('Error: ${jobsProvider.error}'))
              : job == null
                  ? const Center(child: Text('Job not found'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    if (job.companyLogo != null)
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.grey[200],
                                        ),
                                        child: Image.network(
                                          job.companyLogo!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                (job.company ?? 'U')[0].toUpperCase(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
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
                                            job.title,
                                            style: Theme.of(context).textTheme.headlineSmall,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            job.company ?? 'Unknown Company',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_outlined,
                                                  size: 16, color: Colors.grey[600]),
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
                                    Column(
                                      children: [
                                        if (job.suitabilityScore != null)
                                          SuitabilityBadge(
                                            score: job.suitabilityScore,
                                            size: 64,
                                          ),
                                        if (job.affordabilityBadge != null) ...[
                                          const SizedBox(height: 8),
                                          AffordabilityBadge(
                                            badge: job.affordabilityBadge!,
                                            score: (job.affordability?['score'] as num? ?? 0).toInt(),
                                            colorCode: (job.affordability?['colorCode'] ?? 'gray').toString(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSection(
                                  context,
                                  'Salary & Suitability',
                                  _buildSalarySection(context, job),
                                ),
                                const SizedBox(height: 24),
                                _buildSection(
                                  context,
                                  'Cost of Living Breakdown',
                                  _buildCostOfLivingSection(context, job),
                                ),
                                const SizedBox(height: 24),
                                if (job.techStack != null && job.techStack!.isNotEmpty) ...[
                                  _buildSection(
                                    context,
                                    'Tech Stack',
                                    Wrap(
                                      spacing: 8,
                                      children: job.techStack!
                                          .map((tech) => Chip(label: Text(tech)))
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                                _buildSection(
                                  context,
                                  'Job Description',
                                  Text(
                                    job.description ?? 'No description provided',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await jobsProvider.logJobClick(
                                        job.id,
                                        authProvider.token,
                                      );
                                      if (await canLaunchUrl(Uri.parse(job.atsUrl))) {
                                        await launchUrl(
                                          Uri.parse(job.atsUrl),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.open_in_new),
                                    label: const Text('Apply on Company Website'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildSalarySection(BuildContext context, Job job) {
    final score = job.suitabilityScore;

    if (score == null) {
      return Text(
        'Salary data not available',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
      );
    }

    Color scoreColor;
    switch (score.score) {
      case 'GREEN':
        scoreColor = AppTheme.greenScore;
        break;
      case 'YELLOW':
        scoreColor = AppTheme.yellowScore;
        break;
      case 'RED':
        scoreColor = AppTheme.redScore;
        break;
      default:
        scoreColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.1),
            border: Border.all(color: scoreColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scoreColor,
                    ),
                    child: Center(
                      child: Text(
                        score.score[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        score.status,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: scoreColor,
                            ),
                      ),
                      Text(
                        '${score.savingsPercentage.toStringAsFixed(1)}% savings',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scoreColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSalaryRow(context, 'Annual CTC', '₹${score.annualCtc.toStringAsFixed(0)}'),
              _buildSalaryRow(context, 'Net Monthly', '₹${score.netMonthly.toStringAsFixed(0)}'),
              _buildSalaryRow(context, 'Total Expenses', '₹${score.totalExpenses.toStringAsFixed(0)}'),
              _buildSalaryRow(context, 'Disposable Income', '₹${score.disposableIncome.toStringAsFixed(0)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostOfLivingSection(BuildContext context, Job job) {
    final affordability = job.affordability;

    if (affordability == null) {
      return Text(
        'Cost of living data not available',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
      );
    }

    final breakdown = affordability['breakdown'] as Map<String, dynamic>? ?? {};
    final monthlyExpenses = (affordability['monthlyExpenses'] as num? ?? 0).toInt();
    final remainingAmount = (affordability['remainingMonthly'] as num? ?? 0).toInt();
    final score = (affordability['score'] as num? ?? 0).toInt();

    Color scoreColor;
    if (score >= 30) {
      scoreColor = Colors.green;
    } else if (score >= 10) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.1),
            border: Border.all(color: scoreColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Expenses: ₹$monthlyExpenses',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$score%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Remaining: ₹$remainingAmount',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...breakdown.entries.map((entry) {
          final value = (entry.value as num? ?? 0).toInt();
          final percentage = monthlyExpenses > 0
              ? ((value / monthlyExpenses) * 100).toStringAsFixed(1)
              : '0';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key.replaceAll('_', ' ').toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Text(
                      '₹$value',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($percentage%)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
