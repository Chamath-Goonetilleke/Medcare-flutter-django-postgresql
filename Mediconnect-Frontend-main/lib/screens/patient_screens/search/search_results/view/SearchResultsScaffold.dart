import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mediconnect/screens/patient_screens/search/search_results/widgets/widgets.dart'; // For importing common widgets like the ResultCard

class SearchResultsScaffold extends StatelessWidget {
  final String? doctorName;
  final String? disease;
  final String? medicalCenter;
  final String? date;
  final String? time;
  final Map<String, dynamic> searchData; 

  const SearchResultsScaffold({
    super.key,
    this.doctorName,
    this.disease,
    this.medicalCenter,
    this.date,
    this.time, required this.searchData,
  });

  Future<Map<String, dynamic>> fetchSearchResults() async {
    print(doctorName);
    final uri = Uri.parse('http://13.60.21.117:8000/api/doctors/$doctorName/get-all-data');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    if (data['status'] == "success") {
      
      return data['data'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: FutureBuilder<Map<String,dynamic>>(
        future: fetchSearchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          final results = snapshot.data!;
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
             
              return ResultCard(result: results, hospital: medicalCenter!, searchData: searchData,);
            },
          );
        },
      ),
    );
  }
}
