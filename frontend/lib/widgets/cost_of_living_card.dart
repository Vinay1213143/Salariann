import 'package:flutter/material.dart';
import '../services/cost_of_living_service.dart';

class CostOfLivingCard extends StatelessWidget {
  final CostOfLivingData costData;

  const CostOfLivingCard({
    Key? key,
    required this.costData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cost of Living',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  costData.city,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCostRow(
              context,
              'Rent (1BR Center)',
              '₹${costData.rent1brCenter}',
              Icons.home,
            ),
            _buildCostRow(
              context,
              'Grocery',
              '₹${costData.groceryMonthly}',
              Icons.shopping_cart,
            ),
            _buildCostRow(
              context,
              'Transportation',
              '₹${costData.transportation}',
              Icons.directions_bus,
            ),
            _buildCostRow(
              context,
              'Utilities',
              '₹${costData.utilities}',
              Icons.lightbulb,
            ),
            _buildCostRow(
              context,
              'Dining Out',
              '₹${costData.diningOut}',
              Icons.restaurant,
            ),
            _buildCostRow(
              context,
              'Entertainment',
              '₹${costData.entertainment}',
              Icons.movie,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Monthly Expense',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '₹${costData.totalMonthly}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(
    BuildContext context,
    String label,
    String amount,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
