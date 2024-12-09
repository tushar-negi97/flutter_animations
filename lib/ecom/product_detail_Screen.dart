import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final String description;
  final String productId;

  const ProductDetailsScreen({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with TickerProviderStateMixin {
  int _quantity = 1;
  bool _isAddedToCart = false;
  late AnimationController _fadeInController;

  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeInController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeInController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeInController, curve: Curves.easeInOut),
    );

    // Start fade and slide animations when the page is built
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeInController.forward();
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  void _handleQuantityChange(bool increase) {
    setState(() {
      if (increase && _quantity < 10) {
        _quantity++;
      } else if (!increase && _quantity > 1) {
        _quantity--;
      }
    });
  }

  void _handleAddToCart() {
    setState(() {
      _isAddedToCart = !_isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        // backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Hero Animation for Product Image
            Hero(
              tag: 'product-${widget.productId}', // Unique tag for Hero animation
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Product Name & Price

            // Quantity Section with Improved Styling
            Row(
              children: [
                Flexible(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        children: [
                          const Text(
                            "Quantity: ",
                            style: TextStyle(fontSize: 14),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.deepPurple),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _handleQuantityChange(false),
                                  iconSize: 22,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                    child: Text(
                                      _quantity.toString(),
                                      key: ValueKey(_quantity),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _handleQuantityChange(true),
                                  iconSize: 22,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 10),
                //here
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: ElevatedButton(
                        onPressed: _handleAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAddedToCart ? Colors.green : Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: Text(
                            _isAddedToCart ? "Added to Cart" : "Add to Cart",
                            key: ValueKey<bool>(_isAddedToCart),
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),

                        // Text(
                        //   _isAddedToCart ? "Added to Cart" : "Add to Cart",
                        //   style: const TextStyle(fontSize: 16, color: Colors.white),
                        // ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Description Section with Styling
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[100],
                  //   borderRadius: BorderRadius.circular(10),
                  //   boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
                  // ),
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ),

            // Add to Cart Button with Fade Animation

            // Customer Reviews Section with Scrollable Cards
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Customer Reviews",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250, // Fixed height for reviews
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5, // Example reviews count
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(10),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Customer Image
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          'https://randomuser.me/api/portraits/men/1.jpg',
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "John Doe",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "⭐⭐⭐⭐☆",
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Great product! Worth every penny. Highly recommended.",
                                        style: TextStyle(fontSize: 14),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
