import 'package:flutter/material.dart';
import 'package:inter_task/models/poll_option.dart';

class PollPage extends StatefulWidget {
  const PollPage({super.key});

  @override
  State<PollPage> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  List<PollOption> options = [
    PollOption(option: 'Flutter'),
    PollOption(option: 'React Native'),
    PollOption(option: 'Native Android'),
    PollOption(option: 'iOS (SwiftUI)'),
  ];

  bool voted = false;

  void vote(int index) {
    if (!voted) {
      setState(() {
        options[index].votes++;
        voted = true;
      });
    }
  }

  int get totalVotes => options.fold(0, (sum, item) => sum + item.votes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voting / Poll App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Which mobile development framework do you prefer?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              double percent = totalVotes == 0
                  ? 0
                  : (option.votes / totalVotes) * 100;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(option.option),
                  subtitle: voted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: percent / 100,
                              minHeight: 8,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 4),
                            Text('${percent.toStringAsFixed(1)}% (${option.votes} votes)'),
                          ],
                        )
                      : null,
                  trailing: voted
                      ? null
                      : ElevatedButton(
                          onPressed: () => vote(index),
                          child: const Text('Vote'),
                        ),
                ),
              );
            }),
            if (voted)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Thank you for voting!',
                  style: TextStyle(fontSize: 16, color: Colors.green[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}