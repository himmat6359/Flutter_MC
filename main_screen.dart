import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the ApiService

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: SafeArea(
        // Ensure content is within safe areas of the screen
        child: FutureBuilder<List<Product>>(
          future: ApiService.fetchProducts(), // Fetch the products
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading spinner
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text('Error: ${snapshot.error}')); // Show error message
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No data found')); // Handle empty data
            }

            // Data is available, display it in a GridView
            final products = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.all(8.0), // Add padding around the GridView
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  childAspectRatio:
                      0.6, // Adjusted aspect ratio for better fitting
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(
                                    10)), // Rounded top corners for the image
                            child: Image.network(
                              products[index].image,
                              height: 150,
                              fit: BoxFit
                                  .cover, // Ensure image covers the space without distortion
                              width: double
                                  .infinity, // Make image take full width of the card
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              products[index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2, // Limit title to 2 lines
                              overflow:
                                  TextOverflow.ellipsis, // Handle overflow
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '\$${products[index].price.toStringAsFixed(2)}', // Format price to two decimal places
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              products[index].description,
                              maxLines: 3, // Limit description to 3 lines
                              overflow:
                                  TextOverflow.ellipsis, // Handle overflow
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
