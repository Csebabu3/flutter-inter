import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  const ExpenseList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return expenses.isEmpty
        ? const Center(child: Text('No expenses found!'))
        : ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (ctx, index) {
              final e = expenses[index];
              return Card(
                child: ListTile(
                  title: Text(e.title),
                  subtitle: Text('${e.date.toLocal()}'.split(' ')[0]),
                  trailing: Text('₹${e.amount.toStringAsFixed(2)}'),
                ),
              );
            },
          );
  }
}
