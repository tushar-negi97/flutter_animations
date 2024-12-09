import 'package:bloc_app/ecom/product_detail_Screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final Function onCartPressed;
  final Function onCartUnPressed;

  const ProductCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onCartPressed,
    required this.onCartUnPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isAddedToCart = false;

  void _navigateToProductDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          name: widget.name,
          price: widget.price,
          image: widget.image,
          description:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
          productId: widget.name,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleCart() {
    if (_isAddedToCart) {
      widget.onCartUnPressed();

      _controller.reverse();
    } else {
      _controller.forward();
      widget.onCartPressed();
    }
    setState(() {
      _isAddedToCart = !_isAddedToCart;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToProductDetails,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            Expanded(
              child: Hero(
                tag: 'product-${widget.name}', // Unique tag for Hero animation
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Product Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.price,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: _toggleCart,
                    child: AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        final angle = _rotationAnimation.value * 3.14159; // Convert to radians
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // Perspective effect
                            ..rotateY(angle),
                          child: _rotationAnimation.value > 0.5
                              ? const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.deepPurple,
                                  key: ValueKey('added'),
                                )
                              : const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.grey,
                                  key: ValueKey('notAdded'),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Add to Cart Icon
          ],
        ),
      ),
    );
  }
}
