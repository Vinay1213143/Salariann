import 'package:flutter/material.dart';
import '../models/job.dart';
import '../theme/app_theme.dart';

class SuitabilityBadge extends StatelessWidget {
  final SuitabilityScore? score;
  final double? size;

  const SuitabilityBadge({
    Key? key,
    required this.score,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (score == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: size! * 0.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    Color backgroundColor;
    Color textColor = Colors.white;

    switch (score!.score) {
      case 'GREEN':
        backgroundColor = AppTheme.greenScore;
        break;
      case 'YELLOW':
        backgroundColor = AppTheme.yellowScore;
        textColor = Colors.black;
        break;
      case 'RED':
        backgroundColor = AppTheme.redScore;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Tooltip(
          message: '${score!.status}\n${score!.savingsPercentage.toStringAsFixed(1)}% savings',
          child: Text(
            score!.score[0],
            style: TextStyle(
              fontSize: size! * 0.5,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
