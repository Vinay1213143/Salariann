import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/job.dart';

class IndianJobsProvider extends ChangeNotifier {
  List<Job> _indianJobs = [];
  List<Job> _filteredIndianJobs = [];
  Job? _selectedJob;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  int _totalJobs = 0;
  final int _pageSize = 20;

  String? _selectedCity;
  String? _selectedCompany;
  String? _searchQuery;

  List<Job> get indianJobs => _indianJobs;
  List<Job> get filteredIndianJobs => _filteredIndianJobs.isEmpty && _searchQuery == null ? _indianJobs : _filteredIndianJobs;
  Job? get selectedJob => _selectedJob;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalJobs => _totalJobs;
  String? get selectedCity => _selectedCity;
  String? get selectedCompany => _selectedCompany;
  String? get searchQuery => _searchQuery;

  Future<void> fetchIndianJobs({
    String? search,
    String? city,
    String? company,
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

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
        _searchQuery = search;
      }

      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
        _selectedCity = city;
      }

      if (company != null && company.isNotEmpty) {
        queryParams['company'] = company;
        _selectedCompany = company;
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/india/jobs').replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _indianJobs = (data['data'] as List).map((job) => Job.fromJson(job)).toList();
        _filteredIndianJobs = List.from(_indianJobs);
        _totalJobs = data['pagination']?['total'] ?? _indianJobs.length;
        _error = null;
      } else {
        _error = 'Failed to fetch Indian jobs';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterIndianJobs({
    String? searchQuery,
    String? city,
    String? company,
    int? minSalary,
    int? maxSalary,
  }) {
    _filteredIndianJobs = _indianJobs.where((job) {
      final matchSearch = searchQuery == null ||
          searchQuery.isEmpty ||
          job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (job.company?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          (job.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

      final matchCity = city == null || city.isEmpty || job.city == city;

      final matchCompany = company == null || company.isEmpty ||
          (job.company?.toLowerCase().contains(company.toLowerCase()) ?? false);

      final jobSalaryLPA = (job.annualCtcMax ?? 0) / 100000;
      final matchMinSalary = minSalary == null || jobSalaryLPA >= minSalary;
      final matchMaxSalary = maxSalary == null || jobSalaryLPA <= maxSalary;

      return matchSearch && matchCity && matchCompany && matchMinSalary && matchMaxSalary;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchIndianJobById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/india/jobs/$id'))
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

  Future<void> fetchIndianJobsByCompany(String company) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/india/jobs/company/$company'))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _indianJobs = (data['data'] as List).map((job) => Job.fromJson(job)).toList();
        _filteredIndianJobs = List.from(_indianJobs);
        _totalJobs = data['pagination']?['total'] ?? _indianJobs.length;
        _error = null;
      } else {
        _error = 'Failed to fetch company jobs';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _selectedCity = null;
    _selectedCompany = null;
    _searchQuery = null;
    _indianJobs = [];
    _filteredIndianJobs = [];
    _currentPage = 0;
    notifyListeners();
  }
}
