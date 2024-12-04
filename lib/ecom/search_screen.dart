import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // List of products
  final List<String> _allProducts = [
    'Laptop',
    'Smartphone',
    'Headphones',
    'Smartwatch',
    'Tablet',
    'Keyboard',
    'Mouse',
    'Camera',
    'Speakers',
    'Charger',
  ];

  // This list holds the filtered products based on the search
  List<String> _filteredProducts = [];

  // Controller for the search TextField
  final TextEditingController _searchController = TextEditingController();
  bool isSearched = false;
  @override
  void initState() {
    super.initState();
    // _filteredProducts = _allProducts; // Initially show all products
  }

  // Function to filter products based on the search text
  void _filterProducts(String query) {
    setState(() {
      isSearched = true;
      // if (query.isEmpty) {
      //   _filteredProducts = _allProducts; // Show all products if search is empty
      // } else {
      _filteredProducts = _allProducts
          .where((product) => product.toLowerCase().contains(query.toLowerCase()))
          .toList(); // Filter products based on search query
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
        // backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search TextField
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts, // Update filtered products on text change
            ),
            const SizedBox(height: 20),
            // List of filtered products
            Expanded(
              child: _filteredProducts.isEmpty && !isSearched
                  ? Center(child: Lottie.asset('assets/lottie/search.json'))
                  : _filteredProducts.isEmpty && isSearched
                      ? Column(
                          children: [
                            Center(child: Lottie.asset('assets/lottie/not_found.json')),
                            const Text('No Products found!')
                          ],
                        )
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_filteredProducts[index]),
                              trailing: const Icon(Icons.shopping_cart),
                              onTap: () {
                                // Handle product selection
                                print('Selected product: ${_filteredProducts[index]}');
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
