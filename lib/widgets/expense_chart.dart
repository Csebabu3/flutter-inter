import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY() + 50,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < expenses.length) {
                    return Text(
                      expenses[index].title.length > 5
                          ? expenses[index].title.substring(0, 5)
                          : expenses[index].title,
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          barGroups: expenses.asMap().entries.map((entry) {
            int index = entry.key;
            Expense e = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(toY: e.amount, color: Colors.deepPurple),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  double _getMaxY() {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }
}
