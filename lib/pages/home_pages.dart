import 'package:flutter/material.dart';
import 'create_poll_page.dart';
import 'poll_detail_page.dart';
import '../models/poll.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List<Poll> polls = [];

  void addPoll(Poll poll) {
    setState(() => polls.add(poll));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Polls')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPoll = await Navigator.push<Poll>(
            context,
            MaterialPageRoute(builder: (_) => const CreatePollPage()),
          );
          if (newPoll != null) addPoll(newPoll);
        },
        child: const Icon(Icons.add),
      ),
      body: polls.isEmpty
          ? const Center(child: Text('No polls available'))
          : ListView.builder(
              itemCount: polls.length,
              itemBuilder: (context, index) {
                final poll = polls[index];
                return ListTile(
                  title: Text(poll.question),
                  subtitle: Text(poll.isExpired ? 'Expired' : 'Active'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PollDetailPage(poll: poll)),
                    );
                  },
                );
              },
            ),
    );
  }
}
