import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/job.dart';

class JobsProvider extends ChangeNotifier {
  List<Job> _jobs = [];
  List<Job> _filteredJobs = [];
  Job? _selectedJob;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  int _totalJobs = 0;
  final int _pageSize = 20;

  String? _selectedCity;
  String? _selectedRole;

  List<Job> get jobs => _jobs;
  List<Job> get filteredJobs => _filteredJobs;
  Job? get selectedJob => _selectedJob;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalJobs => _totalJobs;
  String? get selectedCity => _selectedCity;
  String? get selectedRole => _selectedRole;

  Future<void> fetchJobs({
    String? city,
    String? role,
    int page = 0,
  }) async {
    _isLoading = true;
    _error = null;
    _currentPage = page;
    notifyListeners();

    try {
      final queryParams = {
        'limit': _pageSize.toString(),
        'offset': (page * _pageSize).toString(),
      };

      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
        _selectedCity = city;
      }

      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
        _selectedRole = role;
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/jobs').replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jobs = (data['data'] as List).map((job) => Job.fromJson(job)).toList();
        _filteredJobs = List.from(_jobs);
        _totalJobs = data['pagination']?['total'] ?? _jobs.length;
        _error = null;
      } else {
        _error = 'Failed to fetch jobs';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterJobs({
    String? searchQuery,
    String? city,
    String? jobType,
    int? minSalary,
    int? maxSalary,
  }) {
    _filteredJobs = _jobs.where((job) {
      final matchSearch = searchQuery == null ||
          searchQuery.isEmpty ||
          job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (job.company?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (job.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      final matchCity = city == null || city.isEmpty || job.city == city;

      final jobSalaryLPA = (job.annualCtcMax ?? 0) / 100000;
      final matchMinSalary = minSalary == null || jobSalaryLPA >= minSalary;
      final matchMaxSalary = maxSalary == null || jobSalaryLPA <= maxSalary;

      final matchType = jobType == null || jobType.isEmpty;

      return matchSearch && matchCity && matchMinSalary && matchMaxSalary && matchType;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchJobById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/jobs/$id'))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        _selectedJob = Job.fromJson(jsonDecode(response.body));
        _error = null;
      } else {
        _error = 'Failed to fetch job details';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logJobClick(String jobId, String? token) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/jobs/click'),
        headers: headers,
        body: jsonEncode({'job_id': jobId}),
      ).timeout(ApiConfig.requestTimeout);
    } catch (e) {
      print('Error logging job click: $e');
    }
  }

  void clearFilters() {
    _selectedCity = null;
    _selectedRole = null;
    _jobs = [];
    _filteredJobs = [];
    _currentPage = 0;
    notifyListeners();
  }
}
