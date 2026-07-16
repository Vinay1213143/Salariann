import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/companies/companies_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/messaging/messaging_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/jobs/job_dashboard_screen.dart';
import '../screens/jobs/job_detail_screen.dart';
import '../screens/companies/company_directory_screen.dart';
import '../screens/companies/company_profile_screen.dart';
import '../screens/contribute/add_review_screen.dart';
import '../screens/contribute/contribute_salary_screen.dart';
import '../screens/contribute/share_interview_screen.dart';
import '../screens/shell/app_shell.dart';
import '../screens/jobs/live_jobs_screen.dart';
import '../screens/salary/salary_suitability_result_screen.dart';
import '../screens/jobs/saved_jobs_screen.dart';
import '../screens/jobs/india_jobs_screen.dart';
import '../screens/companies/india_companies_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/live-jobs',
      builder: (context, state) => const LiveJobsScreen(),
    ),
    GoRoute(
      path: '/salary-suitability',
      builder: (context, state) {
        final salary = double.tryParse(state.uri.queryParameters['salary'] ?? '0') ?? 0;
        final city = state.uri.queryParameters['city'] ?? 'Bangalore';
        final lifestyle = state.uri.queryParameters['lifestyle'] ?? 'single';
        return SalarySuitabilityResultScreen(
          salary: salary,
          city: city,
          lifestyle: lifestyle,
        );
      },
    ),
    GoRoute(
      path: '/saved-jobs',
      builder: (context, state) => const SavedJobsScreen(),
    ),
    GoRoute(
      path: '/india/jobs',
      builder: (context, state) => const IndiaJobsScreen(),
    ),
    GoRoute(
      path: '/india/companies',
      builder: (context, state) => const IndiaCompaniesScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'job/:id',
                  builder: (context, state) => JobDetailScreen(
                    jobId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/companies',
              builder: (context, state) => const CompaniesScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => CompanyProfileScreen(
                    companyId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messaging',
              builder: (context, state) => const MessagingScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'review',
                  builder: (context, state) {
                    final companyId = state.uri.queryParameters['company_id'];
                    return AddReviewScreen(companyId: companyId);
                  },
                ),
                GoRoute(
                  path: 'salary',
                  builder: (context, state) {
                    final companyId = state.uri.queryParameters['company_id'];
                    return ContributeSalaryScreen(companyId: companyId);
                  },
                ),
                GoRoute(
                  path: 'interview',
                  builder: (context, state) {
                    final companyId = state.uri.queryParameters['company_id'];
                    return ShareInterviewScreen(companyId: companyId);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Route not found: ${state.uri}'),
    ),
  ),
);
