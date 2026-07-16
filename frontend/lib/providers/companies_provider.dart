import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/job.dart';

class CompaniesProvider extends ChangeNotifier {
  List<Company> _companies = [];
  Company? _selectedCompany;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  int _totalCompanies = 0;
  final int _pageSize = 20;

  String? _searchQuery;
  String? _selectedCity;

  List<Company> _filteredCompanies = [];

  List<Company> get companies => _companies;
  List<Company> get filteredCompanies => _filteredCompanies.isEmpty && _searchQuery == null ? _companies : _filteredCompanies;
  Company? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalCompanies => _totalCompanies;
  String? get searchQuery => _searchQuery;
  String? get selectedCity => _selectedCity;

  Future<void> fetchCompanies({
    String? search,
    String? city,
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

      final uri = Uri.parse('${ApiConfig.baseUrl}/companies').replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _companies = (data['data'] as List).map((company) => Company.fromJson(company)).toList();
        _filteredCompanies = List.from(_companies);
        _totalCompanies = data['pagination']?['total'] ?? _companies.length;
        _error = null;
      } else {
        _error = 'Failed to fetch companies';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCompanyById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/companies/$id'))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _selectedCompany = Company.fromJson(data);
        _error = null;
      } else {
        _error = 'Failed to fetch company details';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCompanies(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredCompanies = List.from(_companies);
    } else {
      _filteredCompanies = _companies.where((company) {
        return company.name.toLowerCase().contains(query.toLowerCase()) ||
            (company.city?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (company.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = null;
    _selectedCity = null;
    _filteredCompanies = [];
    _companies = [];
    _currentPage = 0;
    notifyListeners();
  }
}
