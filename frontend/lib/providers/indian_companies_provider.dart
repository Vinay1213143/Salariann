import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/job.dart';

class IndianCompaniesProvider extends ChangeNotifier {
  List<Company> _indianCompanies = [];
  Company? _selectedCompany;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  int _totalCompanies = 0;
  final int _pageSize = 20;

  String? _searchQuery;
  String? _selectedCity;
  List<String> _indianCities = [];

  List<Company> get indianCompanies => _indianCompanies;
  Company? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalCompanies => _totalCompanies;
  String? get searchQuery => _searchQuery;
  String? get selectedCity => _selectedCity;
  List<String> get indianCities => _indianCities;

  Future<void> fetchIndianCompanies({
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

      final uri = Uri.parse('${ApiConfig.baseUrl}/india/companies').replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _indianCompanies = (data['data'] as List).map((company) => Company.fromJson(company)).toList();
        _totalCompanies = data['pagination']?['total'] ?? _indianCompanies.length;
        _error = null;
      } else {
        _error = 'Failed to fetch Indian companies';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchIndianCompanyById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/india/companies/$id'))
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

  Future<void> fetchIndianCompaniesByCity(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/india/companies/city/$city'))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _indianCompanies = (data['data'] as List).map((company) => Company.fromJson(company)).toList();
        _totalCompanies = data['pagination']?['total'] ?? _indianCompanies.length;
        _error = null;
      } else {
        _error = 'Failed to fetch companies for city';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchIndianCities() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/india/cities'))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _indianCities = List<String>.from(data['data'] ?? []);
        _error = null;
      } else {
        _error = 'Failed to fetch cities';
      }
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  void searchCompanies(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = null;
    _selectedCity = null;
    _indianCompanies = [];
    _currentPage = 0;
    notifyListeners();
  }
}
