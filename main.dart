import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angel One Portfolio Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<Stock> portfolio = [];

  @override
  void initState() {
    super.initState();
    fetchPortfolio();
  }

  Future<void> fetchPortfolio() async {
    final response = await http.get(Uri.parse('http://localhost:3000/portfolio'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        portfolio = data.map((stock) => Stock.fromJson(stock)).toList();
      });
    } else {
      throw Exception('Failed to load portfolio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Tracker'),
      ),
      body: ListView.builder(
        itemCount: portfolio.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(portfolio[index].symbol),
            subtitle: Text('Quantity: ${portfolio[index].quantity}, Value: \$${portfolio[index].currentValue}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new stock logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Stock {
  final String symbol;
  final int quantity;
  final double currentValue;

  Stock({required this.symbol, required this.quantity, required this.currentValue});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      quantity: json['quantity'],
      currentValue: json['current_value'],
    );
  }
}
