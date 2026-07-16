import 'package:flutter/material.dart';
import '../services/cost_of_living_service.dart';

class CostOfLivingProvider extends ChangeNotifier {
  final CostOfLivingService _service = CostOfLivingService();

  List<Map<String, dynamic>> _supportedCities = [];
  Map<String, CostOfLivingData> _costCache = {};
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get supportedCities => _supportedCities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSupportedCities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _supportedCities = await _service.getSupportedCities();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CostOfLivingData?> getCostOfLiving(String city) async {
    if (_costCache.containsKey(city)) {
      return _costCache[city];
    }

    try {
      final data = await _service.getCostOfLiving(city);
      _costCache[city] = data;
      _error = null;
      notifyListeners();
      return data;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<AffordabilityData?> calculateAffordability(
    int salary,
    String city,
  ) async {
    try {
      final data = await _service.calculateAffordability(salary, city);
      _error = null;
      notifyListeners();
      return data;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearCache() {
    _costCache.clear();
    notifyListeners();
  }
}
