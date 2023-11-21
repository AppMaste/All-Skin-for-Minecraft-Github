import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   Future<List<String>>? apiData1;
   Future<List<String>>? apiData2;

  @override
  void initState() {
    super.initState();
    fetchData1();
  }

  Future<void> fetchData1() async {
    final response1 = await http.get(Uri.parse('https://api.example.com/data1'));

    if (response1.statusCode == 200) {
      // Assuming the API returns a list of strings as a JSON array
      List<String> data = List.from(jsonDecode(response1.body));

      setState(() {
        // Display data from the first API or use it as needed
        apiData1 = Future.value(data);
      });

      // Call the second API after the first one is done
      fetchData2();
    } else {
      throw Exception('Failed to load data from API 1');
    }
  }

  Future<void> fetchData2() async {
    final response2 = await http.get(Uri.parse('https://api.example.com/data2'));

    if (response2.statusCode == 200) {
      // Assuming the API returns a list of strings as a JSON array
      List<String> data = List.from(jsonDecode(response2.body));

      setState(() {
        // Display data from the second API or use it as needed
        apiData2 = Future.value(data);
      });
    } else {
      throw Exception('Failed to load data from API 2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sequential API Calls Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<List<String>>(
              future: apiData1,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Display data from the first API
                  return Column(
                    children: [
                      Text('Data from API 1:'),
                      for (var item in snapshot.data!) Text(item),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: apiData2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Display data from the second API
                  return Column(
                    children: [
                      Text('Data from API 2:'),
                      for (var item in snapshot.data!) Text(item),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
