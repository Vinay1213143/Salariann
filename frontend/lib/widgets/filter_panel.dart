import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  final String? selectedCity;
  final String? selectedJobType;
  final int? minSalary;
  final int? maxSalary;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onJobTypeChanged;
  final Function(int?, int?) onSalaryRangeChanged;

  const FilterPanel({
    Key? key,
    required this.selectedCity,
    required this.selectedJobType,
    required this.minSalary,
    required this.maxSalary,
    required this.onCityChanged,
    required this.onJobTypeChanged,
    required this.onSalaryRangeChanged,
  }) : super(key: key);

  static const List<String> cities = [
    'Bangalore',
    'Mumbai',
    'Delhi',
    'Hyderabad',
    'Pune',
    'Chennai',
    'Kolkata',
    'Noida',
    'Gurgaon',
    'Ahmedabad',
    'Jaipur',
    'Chandigarh',
    'Kochi',
    'Indore',
    'Lucknow',
    'Coimbatore',
    'Thiruvananthapuram',
    'Nagpur',
    'Visakhapatnam',
    'Bhubaneswar',
  ];

  static const List<String> jobTypes = [
    'Full-time',
    'Contract',
    'Part-time',
    'Internship',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCityFilter(context),
          const SizedBox(width: 12),
          _buildJobTypeFilter(context),
          const SizedBox(width: 12),
          _buildSalaryFilter(context),
        ],
      ),
    );
  }

  Widget _buildCityFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedCity,
        hint: const Text('City'),
        underline: const SizedBox(),
        items: cities.map((city) {
          return DropdownMenuItem(
            value: city,
            child: Text(city),
          );
        }).toList(),
        onChanged: onCityChanged,
      ),
    );
  }

  Widget _buildJobTypeFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedJobType,
        hint: const Text('Job Type'),
        underline: const SizedBox(),
        items: jobTypes.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: onJobTypeChanged,
      ),
    );
  }

  Widget _buildSalaryFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton(
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text('Salary Range'),
              SizedBox(width: 8),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: false,
            child: SizedBox(
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Min Salary: ₹${(minSalary ?? 0) ~/ 100000}L',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Slider(
                    value: (minSalary ?? 0).toDouble(),
                    min: 0,
                    max: 5000000,
                    divisions: 50,
                    label: '₹${(minSalary ?? 0) ~/ 100000}L',
                    onChanged: (value) {
                      onSalaryRangeChanged(value.toInt(), maxSalary);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Max Salary: ₹${(maxSalary ?? 5000000) ~/ 100000}L',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Slider(
                    value: (maxSalary ?? 5000000).toDouble(),
                    min: 0,
                    max: 5000000,
                    divisions: 50,
                    label: '₹${(maxSalary ?? 5000000) ~/ 100000}L',
                    onChanged: (value) {
                      onSalaryRangeChanged(minSalary, value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
