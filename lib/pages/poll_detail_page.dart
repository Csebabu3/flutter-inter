import 'package:flutter/material.dart';
import '../models/poll.dart';

class PollDetailPage extends StatefulWidget {
  final Poll poll;

  const PollDetailPage({super.key, required this.poll});

  @override
  State<PollDetailPage> createState() => _PollDetailPageState();
}

class _PollDetailPageState extends State<PollDetailPage> {
  bool hasVoted = false;

  void vote(int index) {
    if (!hasVoted && !widget.poll.isExpired) {
      setState(() {
        widget.poll.options[index].votes++;
        hasVoted = true;
      });
    }
  }

  int get totalVotes => widget.poll.options.fold(0, (sum, o) => sum + o.votes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.poll.question)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Expires at: ${widget.poll.expiresAt}'),
            const SizedBox(height: 20),
            ...widget.poll.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              double percent = totalVotes == 0 ? 0 : (option.votes / totalVotes) * 100;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(option.title),
                  subtitle: hasVoted || widget.poll.isExpired
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(value: percent / 100),
                            Text('${percent.toStringAsFixed(1)}% (${option.votes} votes)'),
                          ],
                        )
                      : null,
                  trailing: !hasVoted && !widget.poll.isExpired
                      ? IconButton(
                          icon: const Icon(Icons.how_to_vote),
                          onPressed: () => vote(index),
                        )
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
