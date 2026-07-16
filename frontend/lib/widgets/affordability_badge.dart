import 'package:flutter/material.dart';

class AffordabilityBadge extends StatelessWidget {
  final String badge;
  final int score;
  final String colorCode;

  const AffordabilityBadge({
    Key? key,
    required this.badge,
    required this.score,
    required this.colorCode,
  }) : super(key: key);

  Color _getColorFromCode(String code) {
    switch (code) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorFromCode(colorCode);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            colorCode == 'green'
                ? Icons.check_circle
                : colorCode == 'yellow'
                    ? Icons.warning
                    : Icons.cancel,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            badge,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$score%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
