import 'package:flutter/material.dart';
import 'package:inter_task/models/expense.dart';
import 'package:inter_task/widgets/expense_chart.dart';
import 'package:inter_task/widgets/expense_form.dart';
import 'package:inter_task/widgets/expense_list.dart';

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});
  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final List<Expense> _userExpenses = [];
  DateTime? _selectedDate;

  List<Expense> get _filteredExpenses {
    if (_selectedDate == null) return _userExpenses;
    return _userExpenses.where((e) =>
        e.date.year == _selectedDate!.year &&
        e.date.month == _selectedDate!.month &&
        e.date.day == _selectedDate!.day).toList();
  }

  void _addExpense(String title, double amount, DateTime date) {
    final newExp = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );
    setState(() => _userExpenses.add(newExp));
  }

  void _openExpenseForm(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => ExpenseForm(onSubmit: _addExpense),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDate),
          IconButton(icon: const Icon(Icons.add), onPressed: () => _openExpenseForm(context)),
        ],
      ),
      body: Column(
        children: [
          ExpenseChart(expenses: _filteredExpenses),
          Expanded(child: ExpenseList(expenses: _filteredExpenses)),
        ],
      ),
    );
  }
}
