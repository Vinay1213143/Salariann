import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AddReviewScreen extends StatefulWidget {
  final String? companyId;

  const AddReviewScreen({
    Key? key,
    this.companyId,
  }) : super(key: key);

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _prosController = TextEditingController();
  final TextEditingController _consController = TextEditingController();

  double _overallRating = 3;
  double _workLifeBalance = 3;
  double _skillDevelopment = 3;
  double _management = 3;

  @override
  void dispose() {
    _prosController.dispose();
    _consController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Review')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in to add a review'),
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
        title: const Text('Add Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share Your Experience',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildRatingSection(
                context,
                'Overall Rating',
                _overallRating,
                (value) {
                  setState(() {
                    _overallRating = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildRatingSection(
                context,
                'Work-Life Balance',
                _workLifeBalance,
                (value) {
                  setState(() {
                    _workLifeBalance = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildRatingSection(
                context,
                'Skill Development',
                _skillDevelopment,
                (value) {
                  setState(() {
                    _skillDevelopment = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _buildRatingSection(
                context,
                'Management',
                _management,
                (value) {
                  setState(() {
                    _management = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _prosController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Pros',
                  hintText: 'What did you like about working here?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _consController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Cons',
                  hintText: 'What could be improved?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review submitted successfully!')),
                    );
                    context.pop();
                  },
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection(
    BuildContext context,
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.toStringAsFixed(1)} / 5',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
