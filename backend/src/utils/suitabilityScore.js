export function calculateSuitabilityScore(annualCtc, cityMetrics) {
  if (!annualCtc || !cityMetrics) {
    return null;
  }

  const netMonthly = (annualCtc / 12) * 0.88;

  const totalExpenses =
    (cityMetrics.avg_rent || 0) +
    (cityMetrics.avg_food || 0) +
    (cityMetrics.avg_commute || 0) +
    (cityMetrics.avg_utilities || 0);

  const disposableIncome = netMonthly - totalExpenses;

  const savingsPercentage = (disposableIncome / netMonthly) * 100;

  let score;
  let status;

  if (savingsPercentage > 30) {
    score = 'GREEN';
    status = 'Comfortable';
  } else if (savingsPercentage >= 10) {
    score = 'YELLOW';
    status = 'Manageable';
  } else {
    score = 'RED';
    status = 'High financial stress';
  }

  return {
    annualCtc,
    netMonthly: Math.round(netMonthly * 100) / 100,
    totalExpenses: Math.round(totalExpenses * 100) / 100,
    disposableIncome: Math.round(disposableIncome * 100) / 100,
    savingsPercentage: Math.round(savingsPercentage * 100) / 100,
    score,
    status,
    breakdown: {
      rent: cityMetrics.avg_rent || 0,
      food: cityMetrics.avg_food || 0,
      commute: cityMetrics.avg_commute || 0,
      utilities: cityMetrics.avg_utilities || 0,
    },
  };
}
