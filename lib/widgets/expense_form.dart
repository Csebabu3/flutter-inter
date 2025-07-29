import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final Function(String, double, DateTime) onSubmit;

  const ExpenseForm({super.key, required this.onSubmit});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submit() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0;
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) return;

    widget.onSubmit(enteredTitle, enteredAmount, _selectedDate!);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) setState(() => _selectedDate = pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Picked: ${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              TextButton(
                onPressed: _presentDatePicker,
                child: const Text('Choose Date'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }
}
