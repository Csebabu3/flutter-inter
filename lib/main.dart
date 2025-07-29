import 'package:flutter/material.dart';
import 'package:inter_task/chat_page.dart';
import 'package:inter_task/pages/LocationMapWeb.dart';
import 'package:inter_task/pages/PollPage.dart';
import 'package:inter_task/pages/expense_home_page.dart';
import 'package:inter_task/pages/home_page.dart';
import 'package:inter_task/pages/login_page.dart';
import 'package:inter_task/screens/product_list_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Intermediate Task in Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/productlist': (context) => const ProductListPage(),
        '/expensetracker': (context) => const ExpenseHomePage(),
        '/chatpage': (context) => const ChatPage(),
        '/votingpoll': (context) => const PollPage(),
        '/votingpolls': (context) => const LoginPage(),
        '/locationtracker': (context) => const LocationSearchMap(),
      },
    );
  }
}

