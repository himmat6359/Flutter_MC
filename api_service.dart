import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final List<Map<String, String>> _users = []; // Store registered users

  // Register a new user
  static String? register(String email, String password) {
    for (var user in _users) {
      if (user['email'] == email) {
        return 'User already exists';
      }
    }
    _users.add({'email': email, 'password': password});
    return null; // Return null if registration is successful
  }

  // Verify user credentials
  static String? login(String email, String password) {
    for (var user in _users) {
      if (user['email'] == email && user['password'] == password) {
        return null; // Return null if login is successful
      }
    }
    return 'Invalid email or password'; // Return error message if login fails
  }

  
  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

// Create a Product model
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.image,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
    );
  }
}
