import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/jobs_provider.dart';
import '../../models/job.dart';
import '../../theme/app_theme.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _headerSearchController = TextEditingController();
  final TextEditingController _jobSearchController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  int _selectedNavIndex = 0;
  String? _selectedCity;
  String? _selectedJobType;
  bool _jobsLoaded = false;

  static const List<String> _cities = [
    'Bangalore', 'Mumbai', 'Delhi', 'Hyderabad', 'Pune',
    'Chennai', 'Kolkata', 'Noida', 'Gurgaon', 'Ahmedabad',
  ];

  static const List<String> _jobTypes = [
    'Full-time', 'Part-time', 'Contract', 'Freelance',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_jobsLoaded) {
        context.read<JobsProvider>().fetchJobs();
        _jobsLoaded = true;
      }
    });
  }

  @override
  void dispose() {
    _headerSearchController.dispose();
    _jobSearchController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<JobsProvider>().filterJobs(
      searchQuery: _jobSearchController.text,
      city: _selectedCity,
      jobType: _selectedJobType,
      minSalary: int.tryParse(_minSalaryController.text),
      maxSalary: int.tryParse(_maxSalaryController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context, authProvider, isMobile),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: isMobile
                        ? _buildMobileLayout(context, authProvider)
                        : isTablet
                            ? _buildTabletLayout(context, authProvider)
                            : _buildDesktopLayout(context, authProvider),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader(BuildContext context, AuthProvider authProvider, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1500),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          child: Row(
            children: [
              // Logo
              Row(
                children: [
                  Icon(Icons.work, color: AppTheme.primaryColor, size: 32),
                  const SizedBox(width: 8),
                  Text('Salariann', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.primaryColor)),
                ],
              ),
              const SizedBox(width: 20),
              // Search
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: TextField(
                      controller: _headerSearchController,
                      decoration: InputDecoration(
                        hintText: 'Search jobs, companies...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (value) {
                        _jobSearchController.text = value;
                        _applyFilters();
                      },
                    ),
                  ),
                ),
              if (!isMobile) const Spacer(),
              // Nav items
              if (!isMobile) ...[
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.public, 'Live Jobs'),
                _buildNavItem(2, Icons.work, 'Jobs'),
                _buildNavItem(3, Icons.chat_bubble, 'Messaging'),
                _buildNavItem(4, Icons.notifications, 'Notifications'),
              ],
              if (!isMobile) const SizedBox(width: 20),
              // Auth buttons
              if (!authProvider.isAuthenticated) ...[
                OutlinedButton(
                  onPressed: () => context.push('/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => context.push('/signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Join Now', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ] else ...[
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'signout') authProvider.signOut();
                    if (value == 'profile') context.push('/home');
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'profile', child: Text('Profile')),
                    const PopupMenuItem(value: 'signout', child: Text('Sign Out')),
                  ],
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      (authProvider.user?.email?.isNotEmpty ?? false) ? authProvider.user!.email![0].toUpperCase() : 'U',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              if (isMobile)
                IconButton(icon: const Icon(Icons.menu), onPressed: () => _showMobileMenu(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _selectedNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        _navigateToPage(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isActive ? AppTheme.primaryColor : Colors.transparent, width: 2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isActive ? AppTheme.primaryColor : Colors.grey.shade600),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, color: isActive ? AppTheme.primaryColor : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0: break;
      case 1: context.push('/live-jobs'); break;
      case 2: context.push('/home'); break;
      case 3: context.push('/home'); break;
      case 4: context.push('/home'); break;
    }
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: const Icon(Icons.home), title: const Text('Home'), onTap: () => Navigator.pop(ctx)),
          ListTile(leading: const Icon(Icons.public), title: const Text('Live Jobs'), onTap: () { Navigator.pop(ctx); context.push('/live-jobs'); }),
          ListTile(leading: const Icon(Icons.work), title: const Text('Jobs'), onTap: () { Navigator.pop(ctx); context.push('/home'); }),
          ListTile(leading: const Icon(Icons.chat_bubble), title: const Text('Messaging'), onTap: () { Navigator.pop(ctx); context.push('/home'); }),
          ListTile(leading: const Icon(Icons.notifications), title: const Text('Notifications'), onTap: () { Navigator.pop(ctx); context.push('/home'); }),
        ],
      ),
    );
  }

  // ===== LAYOUTS =====
  Widget _buildDesktopLayout(BuildContext context, AuthProvider authProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 280, child: _buildLeftSidebar(context, authProvider)),
        const SizedBox(width: 20),
        Expanded(child: _buildMainFeed(context)),
        const SizedBox(width: 20),
        SizedBox(width: 320, child: _buildRightSidebar(context)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, AuthProvider authProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMainFeed(context)),
        const SizedBox(width: 20),
        SizedBox(width: 320, child: _buildRightSidebar(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthProvider authProvider) {
    return _buildMainFeed(context);
  }

  // ===== LEFT SIDEBAR =====
  Widget _buildLeftSidebar(BuildContext context, AuthProvider authProvider) {
    final userName = authProvider.isAuthenticated
        ? (authProvider.user?.userMetadata?['display_name'] ?? authProvider.user?.email ?? 'User')
        : 'Your Name';

    return Column(
      children: [
        // Profile Card
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)]),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(height: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryColor, const Color(0xFF084FA0)]))),
              Transform.translate(
                offset: const Offset(0, -40),
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [AppTheme.primaryColor, const Color(0xFF084FA0)]),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(userName is String ? userName : 'User', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                    const SizedBox(height: 4),
                    Text('Job Seeker', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300))),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(children: [
                              Text('0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                              const SizedBox(height: 2),
                              Text('Profile views', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ]),
                            Column(children: [
                              Text('0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                              const SizedBox(height: 2),
                              Text('Post Impressions', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => authProvider.isAuthenticated ? context.push('/home') : context.push('/login'),
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(vertical: 10)),
                              child: const Text('Edit profile', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => authProvider.isAuthenticated ? context.push('/home') : context.push('/login'),
                              style: OutlinedButton.styleFrom(foregroundColor: AppTheme.primaryColor, side: BorderSide(color: AppTheme.primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(vertical: 10)),
                              child: const Text('View profile', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Saved Items
        _buildSidebarSection('Saved Items', [
          _buildSidebarItem(Icons.bookmark, 'My saved jobs'),
          _buildSidebarItem(Icons.description, 'My saved articles'),
        ]),
        const SizedBox(height: 16),
        // Groups
        _buildSidebarSection('Groups', [
          _buildSidebarItem(Icons.group, 'Tech Professionals'),
          _buildSidebarItem(Icons.group, 'Job Seekers India'),
          _buildSidebarItem(Icons.group, 'Startup Community'),
        ]),
      ],
    );
  }

  Widget _buildSidebarSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)]),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // ===== MAIN FEED =====
  Widget _buildMainFeed(BuildContext context) {
    return Column(
      children: [
        // Post Creator
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)]),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppTheme.primaryColor, const Color(0xFF084FA0)])),
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Start a post, try writing an article',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        filled: true, fillColor: const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.grey.shade300)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPostAction(Icons.image, 'Photo', Colors.blue),
                    _buildPostAction(Icons.videocam, 'Video', Colors.green),
                    _buildPostAction(Icons.article, 'Article', Colors.orange),
                    _buildPostAction(Icons.poll, 'Poll', Colors.red),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Filters
        _buildFiltersSection(),
        const SizedBox(height: 16),
        // Jobs Feed
        _buildJobsFeed(context),
      ],
    );
  }

  Widget _buildPostAction(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)]),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Jobs
          const Text('Search Jobs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(
            controller: _jobSearchController,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              hintText: 'Job title, company...',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppTheme.primaryColor)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 16),
          // City
          const Text('City', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppTheme.primaryColor)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('All Cities', style: TextStyle(fontSize: 13)),
            items: [
              const DropdownMenuItem<String>(value: null, child: Text('All Cities', style: TextStyle(fontSize: 13))),
              ..._cities.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))),
            ],
            onChanged: (v) { setState(() => _selectedCity = v); _applyFilters(); },
          ),
          const SizedBox(height: 16),
          // Salary Range
          const Text('Salary Range (LPA)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(
            controller: _minSalaryController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              hintText: 'Min',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _maxSalaryController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _applyFilters(),
            decoration: InputDecoration(
              hintText: 'Max',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 16),
          // Job Type
          const Text('Job Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedJobType,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppTheme.primaryColor)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('All Types', style: TextStyle(fontSize: 13)),
            items: [
              const DropdownMenuItem<String>(value: null, child: Text('All Types', style: TextStyle(fontSize: 13))),
              ..._jobTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))),
            ],
            onChanged: (v) { setState(() => _selectedJobType = v); _applyFilters(); },
          ),
        ],
      ),
    );
  }

  Widget _buildJobsFeed(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (context, jobsProvider, child) {
        if (jobsProvider.isLoading) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SizedBox(width: 40, height: 40, child: CircularProgressIndicator(strokeWidth: 3, color: AppTheme.primaryColor)),
                const SizedBox(height: 20),
                Text('Loading amazing opportunities...', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          );
        }

        final jobs = jobsProvider.filteredJobs;

        if (jobs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text('No jobs found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text('Try adjusting your filters or search terms', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          );
        }

        return Column(
          children: jobs.map((job) => _buildJobCard(context, job)).toList(),
        );
      },
    );
  }

  // ===== JOB CARD =====
  Widget _buildJobCard(BuildContext context, Job job) {
    final salary = job.annualCtcMax != null ? '${(job.annualCtcMax! / 100000).toStringAsFixed(1)}L' : 'Not disclosed';
    final affordability = job.affordability;
    final affordabilityLevel = affordability?['level'] ?? 'Affordable';
    final affordabilityColor = affordability?['colorCode'] ?? 'green';
    final postedDate = DateFormat('M/d/yyyy').format(job.postedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)],
        border: const Border(left: BorderSide(color: Color(0xFF0A66C2), width: 4)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: LinearGradient(colors: [AppTheme.primaryColor, const Color(0xFF084FA0)])),
                child: const Icon(Icons.business, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                    const SizedBox(height: 4),
                    Text(job.company ?? 'Company Name', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(job.city, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(postedDate, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Description
          if (job.description != null) ...[
            const SizedBox(height: 12),
            Text(
              job.description!.length > 250 ? '${job.description!.substring(0, 250)}...' : job.description!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
            ),
          ],
          // Tags
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _buildTag(Icons.work, 'Full-time'),
              _buildTag(Icons.school, 'Experience'),
              _buildTag(Icons.code, 'Technical'),
            ],
          ),
          // Salary
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: salary == 'Not disclosed' ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(salary == 'Not disclosed' ? '\u{1F525}' : '\u{1F4B0}', style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Text(salary, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: salary == 'Not disclosed' ? const Color(0xFFE65100) : const Color(0xFF2E7D32))),
              ],
            ),
          ),
          // Affordability
          const SizedBox(height: 8),
          _buildAffordabilityBadge(affordabilityLevel, affordabilityColor),
          // Footer
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('234 applicants', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.bookmark_outline, size: 16, color: AppTheme.primaryColor),
                      label: Text('Save', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/home/job/${job.id}'),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Easy Apply', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
        ],
      ),
    );
  }

  Widget _buildAffordabilityBadge(String level, String colorCode) {
    Color bgColor, textColor;
    switch (colorCode) {
      case 'green':
        bgColor = const Color(0xFFE8F5E9); textColor = const Color(0xFF2E7D32); break;
      case 'yellow':
        bgColor = const Color(0xFFFFF3E0); textColor = const Color(0xFFE65100); break;
      case 'red':
        bgColor = const Color(0xFFFFEBEE); textColor = const Color(0xFFC62828); break;
      default:
        bgColor = const Color(0xFFE8F5E9); textColor = const Color(0xFF2E7D32);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(level, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
    );
  }

  // ===== RIGHT SIDEBAR =====
  Widget _buildRightSidebar(BuildContext context) {
    return Column(
      children: [
        // Trending
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)]),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.newspaper, size: 16, color: AppTheme.primaryColor),
                  const SizedBox(width: 6),
                  const Text('Trending in India', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                ],
              ),
              const SizedBox(height: 12),
              _buildNewsItem('Tech Jobs Boom', '15.2K followers'),
              _buildNewsItem('Startup Funding', '8.5K followers'),
              _buildNewsItem('Remote Work Trends', '12.3K followers'),
              _buildNewsItem('Salary Insights', '9.8K followers'),
              _buildNewsItem('Career Development', '11.2K followers'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Tips
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3)]),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, size: 16, color: Colors.amber.shade700),
                  const SizedBox(width: 6),
                  const Text('Tips', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                ],
              ),
              const SizedBox(height: 12),
              _buildTipItem('Optimize your profile', 'Get more visibility'),
              _buildTipItem('Network effectively', 'Build connections'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItem(String title, String meta) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 4),
          Text(meta, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTipItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
