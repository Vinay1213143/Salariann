import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class SalarySuitabilityResultScreen extends StatefulWidget {
  final double salary;
  final String city;
  final String lifestyle;

  const SalarySuitabilityResultScreen({
    Key? key,
    required this.salary,
    required this.city,
    required this.lifestyle,
  }) : super(key: key);

  @override
  State<SalarySuitabilityResultScreen> createState() => _SalarySuitabilityResultScreenState();
}

class _SalarySuitabilityResultScreenState extends State<SalarySuitabilityResultScreen> {
  late SalarySuitabilityResult _result;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _calculateSuitability();
  }

  void _calculateSuitability() {
    try {
      _result = SalarySuitabilityCalculator.calculate(
        annualSalary: widget.salary,
        city: widget.city,
        lifestyle: widget.lifestyle,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Suitability'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSuitabilityScore(),
                      _buildExpenseBreakdown(),
                      _buildFinancialBreakdown(),
                      _buildRecommendations(),
                      if (authProvider.isAuthenticated) _buildSaveButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSuitabilityScore() {
    final scoreColor = _getScoreColor(_result.score);
    final scoreLabel = _getScoreLabel(_result.score);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor.withOpacity(0.8), scoreColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Salary Suitability Score',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: scoreColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_result.savingsPercentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Savings',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              scoreLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _result.recommendation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Expense Breakdown',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _buildExpenseItem('Rent', _result.breakdown['rent'] ?? 0),
          _buildExpenseItem('Food', _result.breakdown['food'] ?? 0),
          _buildExpenseItem('Commute', _result.breakdown['commute'] ?? 0),
          _buildExpenseItem('Utilities', _result.breakdown['utilities'] ?? 0),
          _buildExpenseItem('Entertainment', _result.breakdown['entertainment'] ?? 0),
          _buildExpenseItem('Healthcare', _result.breakdown['healthcare'] ?? 0),
          const Divider(height: 24),
          _buildExpenseItem(
            'Total Expenses',
            _result.totalExpenses,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String label, double amount, {bool isTotal = false}) {
    final percentage = _result.netMonthly > 0
        ? ((amount / _result.netMonthly) * 100).clamp(0.0, 100.0).toDouble()
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
          if (!isTotal) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (percentage / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(percentage),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${percentage.toStringAsFixed(1)}% of income',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdown() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _buildSummaryCard(
            'Annual Salary',
            '₹${_result.annualSalary.toStringAsFixed(0)}',
            Colors.blue,
          ),
          _buildSummaryCard(
            'Monthly Net Income',
            '₹${_result.netMonthly.toStringAsFixed(0)}',
            Colors.green,
          ),
          _buildSummaryCard(
            'Monthly Expenses',
            '₹${_result.totalExpenses.toStringAsFixed(0)}',
            Colors.orange,
          ),
          _buildSummaryCard(
            'Disposable Income',
            '₹${_result.disposableIncome.toStringAsFixed(0)}',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = _getDetailedRecommendations();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...recommendations.map((rec) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rec,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Salary suitability result saved!')),
            );
          },
          icon: const Icon(Icons.bookmark),
          label: const Text('Save Result'),
        ),
      ),
    );
  }

  Color _getScoreColor(String score) {
    switch (score) {
      case 'GREEN':
        return Colors.green;
      case 'YELLOW':
        return Colors.orange;
      case 'RED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getScoreLabel(String score) {
    switch (score) {
      case 'GREEN':
        return 'Comfortable';
      case 'YELLOW':
        return 'Manageable';
      case 'RED':
        return 'Challenging';
      default:
        return 'Unknown';
    }
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 30) return Colors.green;
    if (percentage < 50) return Colors.orange;
    return Colors.red;
  }

  List<String> _getDetailedRecommendations() {
    final recommendations = <String>[];

    if (_result.savingsPercentage > 30) {
      recommendations.add('Excellent savings rate! Consider investing for long-term growth.');
    } else if (_result.savingsPercentage > 10) {
      recommendations.add('Good savings rate. You have a healthy financial cushion.');
    } else {
      recommendations.add('Consider negotiating a higher salary or reducing expenses.');
    }

    if (_result.breakdown['rent']! > _result.netMonthly * 0.4) {
      recommendations.add('Rent is consuming more than 40% of income. Consider relocating.');
    }

    if (_result.lifestyle == 'family') {
      recommendations.add('Family lifestyle selected. Budget includes family expenses.');
    }

    recommendations.add('Review your expenses monthly to maintain financial health.');

    return recommendations;
  }
}

class SalarySuitabilityResult {
  final double annualSalary;
  final double netMonthly;
  final double totalExpenses;
  final double disposableIncome;
  final double savingsPercentage;
  final String score;
  final String recommendation;
  final Map<String, double> breakdown;
  final String lifestyle;

  SalarySuitabilityResult({
    required this.annualSalary,
    required this.netMonthly,
    required this.totalExpenses,
    required this.disposableIncome,
    required this.savingsPercentage,
    required this.score,
    required this.recommendation,
    required this.breakdown,
    required this.lifestyle,
  });
}

class SalarySuitabilityCalculator {
  static final Map<String, Map<String, double>> _cityMetrics = {
    'Bangalore': {
      'single': 15000,
      'family': 25000,
    },
    'Hyderabad': {
      'single': 12000,
      'family': 20000,
    },
    'Pune': {
      'single': 11000,
      'family': 18000,
    },
    'Mumbai': {
      'single': 20000,
      'family': 35000,
    },
    'Delhi': {
      'single': 15000,
      'family': 25000,
    },
    'Gurgaon': {
      'single': 16000,
      'family': 26000,
    },
    'Noida': {
      'single': 12000,
      'family': 20000,
    },
    'Chennai': {
      'single': 10000,
      'family': 16000,
    },
  };

  static SalarySuitabilityResult calculate({
    required double annualSalary,
    required String city,
    required String lifestyle,
  }) {
    const taxRate = 0.20;
    const netMonthlyFactor = 0.8;

    final netMonthly = (annualSalary / 12) * netMonthlyFactor;

    final baseExpense = _cityMetrics[city]?[lifestyle] ?? 15000;
    final breakdown = _calculateBreakdown(baseExpense);
    final totalExpenses = breakdown.values.fold(0.0, (a, b) => a + b);

    final disposableIncome = netMonthly - totalExpenses;
    final savingsPercentage = (disposableIncome / netMonthly) * 100;

    final score = _calculateScore(savingsPercentage);
    final recommendation = _getRecommendation(score, savingsPercentage);

    return SalarySuitabilityResult(
      annualSalary: annualSalary,
      netMonthly: netMonthly,
      totalExpenses: totalExpenses,
      disposableIncome: disposableIncome,
      savingsPercentage: savingsPercentage,
      score: score,
      recommendation: recommendation,
      breakdown: breakdown,
      lifestyle: lifestyle,
    );
  }

  static Map<String, double> _calculateBreakdown(double baseExpense) {
    return {
      'rent': baseExpense * 0.4,
      'food': baseExpense * 0.25,
      'commute': baseExpense * 0.1,
      'utilities': baseExpense * 0.1,
      'entertainment': baseExpense * 0.1,
      'healthcare': baseExpense * 0.05,
    };
  }

  static String _calculateScore(double savingsPercentage) {
    if (savingsPercentage > 30) return 'GREEN';
    if (savingsPercentage > 10) return 'YELLOW';
    return 'RED';
  }

  static String _getRecommendation(String score, double savingsPercentage) {
    switch (score) {
      case 'GREEN':
        return 'Your salary provides excellent financial stability with ${savingsPercentage.toStringAsFixed(1)}% savings rate';
      case 'YELLOW':
        return 'Your salary is manageable with ${savingsPercentage.toStringAsFixed(1)}% savings rate';
      case 'RED':
        return 'Your salary may be tight with ${savingsPercentage.toStringAsFixed(1)}% savings rate';
      default:
        return 'Unable to calculate suitability';
    }
  }
}
