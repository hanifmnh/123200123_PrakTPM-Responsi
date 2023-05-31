import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail_food.dart';

class ListFood extends StatefulWidget {
  const ListFood({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  _ListFoodState createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  List<dynamic> foods = [];

  @override
  void initState() {
    super.initState();
    fetchFood();
  }

  Future<void> fetchFood() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        foods = data['meals'];
      });
    } else {
      throw Exception('Failed to fetch foods');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => DetailFood(food: food),
              ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      food['strMealThumb'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      food['strMeal'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
