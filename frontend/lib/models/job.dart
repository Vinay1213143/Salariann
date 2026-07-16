class Job {
  final String id;
  final String title;
  final String? description;
  final String city;
  final String? country;
  final double? annualCtcMin;
  final double? annualCtcMax;
  final List<String>? techStack;
  final String atsUrl;
  final DateTime postedAt;
  final bool isActive;
  final String companyId;
  final String? company;
  final String? companyLogo;
  final bool? isRemote;
  final String? source;
  final SuitabilityScore? suitabilityScore;
  final Map<String, dynamic>? affordability;
  final String? affordabilityBadge;

  Job({
    required this.id,
    required this.title,
    this.description,
    required this.city,
    this.country,
    this.annualCtcMin,
    this.annualCtcMax,
    this.techStack,
    required this.atsUrl,
    required this.postedAt,
    required this.isActive,
    required this.companyId,
    this.company,
    this.companyLogo,
    this.isRemote,
    this.source,
    this.suitabilityScore,
    this.affordability,
    this.affordabilityBadge,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // Parse affordability data
    Map<String, dynamic>? affordability;
    if (json['affordability'] != null) {
      final aff = json['affordability'] as Map<String, dynamic>;
      affordability = {
        'score': aff['score'] ?? 0,
        'level': aff['level'] ?? 'Unknown',
        'colorCode': aff['colorCode'] ?? 'gray',
        'monthlyExpenses': aff['monthlyExpenses'] ?? 0,
        'remainingMonthly': aff['remainingMonthly'] ?? 0,
        'breakdown': aff['breakdown'] ?? {},
        'source': aff['source'] ?? 'fallback',
      };
    }

    // Handle both database and API salary fields
    double? salaryMin = json['annual_ctc_min']?.toDouble() ?? json['salary_min']?.toDouble();
    double? salaryMax = json['annual_ctc_max']?.toDouble() ?? json['salary_max']?.toDouble();

    return Job(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      city: json['city'] ?? '',
      country: json['country'],
      annualCtcMin: salaryMin,
      annualCtcMax: salaryMax,
      techStack: json['tech_stack'] != null ? List<String>.from(json['tech_stack']) : null,
      atsUrl: json['ats_url'] ?? json['apply_link'] ?? '',
      postedAt: DateTime.parse(json['posted_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
      companyId: json['company_id'] ?? '',
      company: json['company'],
      companyLogo: json['company_logo'],
      isRemote: json['is_remote'],
      source: json['source'],
      suitabilityScore:
          json['suitabilityScore'] != null ? SuitabilityScore.fromJson(json['suitabilityScore']) : null,
      affordability: affordability,
      affordabilityBadge: json['affordabilityBadge'] as String?,
    );
  }
}

class Company {
  final String id;
  final String name;
  final String? logoUrl;
  final String? website;
  final int? employeeCount;
  final String? description;
  final String? city;
  final int? foundedYear;
  final double? rating;
  final int? totalReviews;
  final Map<String, dynamic>? stats;
  final List<dynamic>? jobs;
  final List<dynamic>? reviews;
  final List<dynamic>? salaries;
  final List<dynamic>? interviews;

  Company({
    required this.id,
    required this.name,
    this.logoUrl,
    this.website,
    this.employeeCount,
    this.description,
    this.city,
    this.foundedYear,
    this.rating,
    this.totalReviews,
    this.stats,
    this.jobs,
    this.reviews,
    this.salaries,
    this.interviews,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logo_url'],
      website: json['website'],
      employeeCount: json['employee_count'],
      description: json['description'],
      city: json['city'],
      foundedYear: json['founded_year'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      totalReviews: json['total_reviews'],
      stats: json['stats'] as Map<String, dynamic>?,
      jobs: json['jobs'] as List<dynamic>?,
      reviews: json['reviews'] as List<dynamic>?,
      salaries: json['salaries'] as List<dynamic>?,
      interviews: json['interviews'] as List<dynamic>?,
    );
  }
}

class SuitabilityScore {
  final double annualCtc;
  final double netMonthly;
  final double totalExpenses;
  final double disposableIncome;
  final double savingsPercentage;
  final String score;
  final String status;
  final Map<String, double> breakdown;

  SuitabilityScore({
    required this.annualCtc,
    required this.netMonthly,
    required this.totalExpenses,
    required this.disposableIncome,
    required this.savingsPercentage,
    required this.score,
    required this.status,
    required this.breakdown,
  });

  factory SuitabilityScore.fromJson(Map<String, dynamic> json) {
    return SuitabilityScore(
      annualCtc: (json['annualCtc'] ?? 0).toDouble(),
      netMonthly: (json['netMonthly'] ?? 0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0).toDouble(),
      disposableIncome: (json['disposableIncome'] ?? 0).toDouble(),
      savingsPercentage: (json['savingsPercentage'] ?? 0).toDouble(),
      score: json['score'] ?? 'YELLOW',
      status: json['status'] ?? 'Manageable',
      breakdown: Map<String, double>.from(
        (json['breakdown'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ) ??
            {},
      ),
    );
  }
}
