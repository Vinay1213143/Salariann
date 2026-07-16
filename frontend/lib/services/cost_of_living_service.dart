import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class CostOfLivingData {
  final String city;
  final int rent1brCenter;
  final int rent1brOutside;
  final int groceryMonthly;
  final int transportation;
  final int utilities;
  final int diningOut;
  final int entertainment;
  final int totalMonthly;
  final String currency;

  CostOfLivingData({
    required this.city,
    required this.rent1brCenter,
    required this.rent1brOutside,
    required this.groceryMonthly,
    required this.transportation,
    required this.utilities,
    required this.diningOut,
    required this.entertainment,
    required this.totalMonthly,
    required this.currency,
  });

  factory CostOfLivingData.fromJson(Map<String, dynamic> json) {
    return CostOfLivingData(
      city: json['city'] ?? '',
      rent1brCenter: json['rent_1br_center'] ?? 0,
      rent1brOutside: json['rent_1br_outside'] ?? 0,
      groceryMonthly: json['grocery_monthly'] ?? 0,
      transportation: json['transportation'] ?? 0,
      utilities: json['utilities'] ?? 0,
      diningOut: json['dining_out'] ?? 0,
      entertainment: json['entertainment'] ?? 0,
      totalMonthly: json['total_monthly'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }
}

class AffordabilityData {
  final String city;
  final int salary;
  final int monthlyExpenses;
  final int remainingAmount;
  final int affordabilityScore;
  final String affordabilityLevel;
  final String colorCode;
  final Map<String, int> breakdown;

  AffordabilityData({
    required this.city,
    required this.salary,
    required this.monthlyExpenses,
    required this.remainingAmount,
    required this.affordabilityScore,
    required this.affordabilityLevel,
    required this.colorCode,
    required this.breakdown,
  });

  factory AffordabilityData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return AffordabilityData(
      city: data['city'] ?? '',
      salary: (data['salary'] ?? 0).toInt(),
      monthlyExpenses: (data['monthlyExpenses'] ?? 0).toInt(),
      remainingAmount: (data['remainingAmount'] ?? 0).toInt(),
      affordabilityScore: (data['affordabilityScore'] ?? 0).toInt(),
      affordabilityLevel: data['affordabilityLevel'] ?? 'Unknown',
      colorCode: data['colorCode'] ?? 'gray',
      breakdown: Map<String, int>.from(
        (data['breakdown'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toInt()),
            ) ??
            {},
      ),
    );
  }
}

class CostOfLivingService {
  static final CostOfLivingService _instance = CostOfLivingService._internal();

  factory CostOfLivingService() {
    return _instance;
  }

  CostOfLivingService._internal();

  Future<List<Map<String, dynamic>>> getSupportedCities() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cost-of-living/cities'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final cities = List<Map<String, dynamic>>.from(json['data'] ?? []);
        return cities;
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<CostOfLivingData> getCostOfLiving(String city) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cost-of-living/$city'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CostOfLivingData.fromJson(json['data']);
      } else {
        throw Exception('City not found');
      }
    } catch (e) {
      throw Exception('Error fetching cost of living: $e');
    }
  }

  Future<AffordabilityData> calculateAffordability(
    int salary,
    String city,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/affordability?salary=$salary&city=$city',
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AffordabilityData.fromJson(json);
      } else {
        throw Exception('Failed to calculate affordability');
      }
    } catch (e) {
      throw Exception('Error calculating affordability: $e');
    }
  }

  Future<List<CostOfLivingData>> getAllCostOfLiving() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cost-of-living'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final cities = List<Map<String, dynamic>>.from(json['data'] ?? []);
        return cities.map((city) => CostOfLivingData.fromJson(city)).toList();
      } else {
        throw Exception('Failed to load cost of living data');
      }
    } catch (e) {
      throw Exception('Error fetching cost of living data: $e');
    }
  }
}
