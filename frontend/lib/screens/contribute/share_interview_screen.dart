import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ShareInterviewScreen extends StatefulWidget {
  final String? companyId;

  const ShareInterviewScreen({
    Key? key,
    this.companyId,
  }) : super(key: key);

  @override
  State<ShareInterviewScreen> createState() => _ShareInterviewScreenState();
}

class _ShareInterviewScreenState extends State<ShareInterviewScreen> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _questionsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  double _difficulty = 3;
  String _result = 'pending';

  @override
  void dispose() {
    _roleController.dispose();
    _questionsController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Share Interview Experience')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in to share interview experience'),
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
        title: const Text('Share Interview Experience'),
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
                'Share Your Interview Experience',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Help candidates prepare by sharing your interview experience',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: 'Job Role',
                  hintText: 'e.g., Senior Software Engineer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Difficulty Level',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_difficulty.toStringAsFixed(0)} / 5',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _difficulty,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        _difficulty = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _questionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Interview Questions',
                  hintText: 'List the questions you were asked...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _experienceController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Your Experience',
                  hintText: 'Describe your interview experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _result,
                decoration: InputDecoration(
                  labelText: 'Result',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'selected', child: Text('Selected')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
                onChanged: (value) {
                  setState(() {
                    _result = value ?? 'pending';
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Interview experience shared successfully!')),
                    );
                    context.pop();
                  },
                  child: const Text('Share Experience'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
