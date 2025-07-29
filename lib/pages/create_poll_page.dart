import 'package:flutter/material.dart';
import '../models/poll.dart';

class CreatePollPage extends StatefulWidget {
  const CreatePollPage({super.key});

  @override
  State<CreatePollPage> createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {
  final questionController = TextEditingController();
  final optionControllers = List.generate(4, (_) => TextEditingController());

  void submitPoll() {
    final question = questionController.text.trim();
    final options = optionControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

    if (question.isEmpty || options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
      return;
    }

    final poll = Poll(
      question: question,
      options: options.map((o) => PollOption(title: o)).toList(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
    );

    Navigator.pop(context, poll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Poll')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: questionController, decoration: const InputDecoration(labelText: 'Question')),
            const SizedBox(height: 10),
            ...List.generate(4, (i) => TextField(controller: optionControllers[i], decoration: InputDecoration(labelText: 'Option ${i + 1}'))),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submitPoll, child: const Text('Create Poll')),
          ],
        ),
      ),
    );
  }
}
