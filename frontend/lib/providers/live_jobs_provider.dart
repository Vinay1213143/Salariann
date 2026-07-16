import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class LiveJob {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final String? companyWebsite;
  final String city;
  final String? country;
  final String? description;
  final String? employmentType;
  final bool isRemote;
  final double? salaryMin;
  final double? salaryMax;
  final String? salaryPeriod;
  final String? postedAt;
  final String? applyLink;
  final List<String> techStack;
  final String source;

  LiveJob({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    this.companyWebsite,
    required this.city,
    this.country,
    this.description,
    this.employmentType,
    this.isRemote = false,
    this.salaryMin,
    this.salaryMax,
    this.salaryPeriod,
    this.postedAt,
    this.applyLink,
    this.techStack = const [],
    required this.source,
  });

  factory LiveJob.fromJson(Map<String, dynamic> json) {
    return LiveJob(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      company: json['company'] ?? 'Unknown',
      companyLogo: json['company_logo'],
      companyWebsite: json['company_website'],
      city: json['city'] ?? 'Remote',
      country: json['country'],
      description: json['description'],
      employmentType: json['employment_type'],
      isRemote: json['is_remote'] ?? false,
      salaryMin: json['salary_min']?.toDouble(),
      salaryMax: json['salary_max']?.toDouble(),
      salaryPeriod: json['salary_period'],
      postedAt: json['posted_at'],
      applyLink: json['apply_link'],
      techStack: json['tech_stack'] != null
          ? List<String>.from(json['tech_stack'])
          : [],
      source: json['source'] ?? 'unknown',
    );
  }
}

class LiveJobsProvider extends ChangeNotifier {
  List<LiveJob> _jobs = [];
  bool _isLoading = false;
  String? _error;
  int _total = 0;
  Map<String, int> _sourceStats = {};

  List<LiveJob> get jobs => _jobs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get total => _total;
  Map<String, int> get sourceStats => _sourceStats;

  Future<void> fetchLiveJobs({
    String? query,
    String? city,
    String? sources,
    int page = 1,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final queryParams = <String, String>{};
      if (query != null && query.isNotEmpty) queryParams['query'] = query;
      if (city != null && city.isNotEmpty) queryParams['city'] = city;
      if (sources != null && sources.isNotEmpty) queryParams['sources'] = sources;
      queryParams['page'] = page.toString();

      final uri = Uri.parse('${ApiConfig.baseUrl}/live/jobs')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jobs = (data['data'] as List)
            .map((j) => LiveJob.fromJson(j))
            .toList();
        _total = data['total'] ?? _jobs.length;
        _sourceStats = Map<String, int>.from(
          (data['sources'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, (v as num).toInt()),
              ) ??
              {},
        );
        _error = null;
      } else {
        _error = 'Failed to fetch live jobs';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
