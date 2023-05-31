import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailFood extends StatefulWidget {
  const DetailFood({Key? key, required this.food}) : super(key: key);

  final dynamic food;

  @override
  _DetailFoodState createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  dynamic meal;

  @override
  void initState() {
    super.initState();
    fetchFoodDetail();
  }

  Future<void> fetchFoodDetail() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.food['idMeal']}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        meal = data['meals'][0];
      });
    } else {
      throw Exception('Failed to fetch detail food');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${meal['strMeal']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                meal['strMealThumb'],
                fit: BoxFit.cover,
                height: 200,
                width: 350,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Category: ${meal['strCategory']}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              'Area: ${meal['strArea']}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${meal['strInstructions']}',
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
