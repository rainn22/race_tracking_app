import 'package:flutter/material.dart';
 

 class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;
 

  const ResultScreen({super.key, required this.results});
 

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Race Results'),
  centerTitle: true,
  ),
  body: ListView.builder(
  itemCount: results.length,
  itemBuilder: (context, index) {
  final result = results[index];
  return Card(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text('Bib: ${result['bib'] ?? 'N/A'}'),
  Text('Name: ${result['name'] ?? 'N/A'}'),
  Text('Time: ${result['time'] ?? 'N/A'}'),
  ],
  ),
  ),
  );
  },
  ),
  );
  }
 }