import 'package:bloc_app/ecom/cart_screen.dart';
import 'package:bloc_app/ecom/widgets/animated_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _categoryController;
  late AnimationController _productController;
  List<CartItem> cartItems = [];
  int cartItemCount = 0;
  bool refreshCart = false;
  void _incrementCartItemCount(CartItem item) {
    cartItems.add(item);
    setState(() {
      cartItemCount = cartItems.length;
    });
    print('Hoiiiii  _incrementCartItemCount=== > $cartItemCount');
  }

  void _decrementCartItemCount(CartItem item) {
    print(item.id);
    cartItems.removeAt(cartItems.firstWhere((test) => test.id == item.id).id);
    setState(() {
      cartItemCount = cartItems.length;
    });
    print('Hoiiiii  _decrementCartItemCount=== > $cartItemCount');
  }

  @override
  void initState() {
    super.initState();

    _categoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _productController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // Start animations
    _categoryController.forward();
    _productController.forward();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () async {
                  var result = await Navigator.pushNamed(context, '/cart', arguments: cartItems);
                  if (result != null) {
                    cartItems.clear();
                    cartItems.addAll(result as List<CartItem>);
                    setState(() {
                      cartItemCount = cartItems.length;
                      refreshCart = !refreshCart;
                    });
                  }

                  // Cart button pressed
                },
              ),
              Positioned(
                right: 5,
                top: 2,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.8), // Slide from above
                          end: Offset.zero, // Final position
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: cartItemCount > 0
                      ? Container(
                          key: ValueKey<int>(cartItemCount),
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Carousel Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CarouselSlider(
              items: [
                _buildCarouselImage(
                  "https://rukminim2.flixcart.com/fk-p-flap/1620/270/image/dd484f1b19c67712.jpg?q=20",
                ),
                _buildCarouselImage(
                  "https://rukminim2.flixcart.com/fk-p-flap/1620/270/image/69841ae2338de519.jpeg?q=20",
                ),
                _buildCarouselImage(
                  "https://rukminim2.flixcart.com/fk-p-flap/1620/270/image/1316eb53d6f52c71.jpg?q=20",
                ),
              ],
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.easeInOutBack,
                autoPlayInterval: const Duration(seconds: 4),
              ),
            ),
          ),

          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AnimatedBuilder(
              animation: _categoryController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _categoryController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_categoryController),
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          CategoryCard(name: "Electronics"),
                          CategoryCard(name: "Fashion"),
                          CategoryCard(name: "Home"),
                          CategoryCard(name: "Beauty"),
                          CategoryCard(name: "Toys"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Products Section
          Expanded(
            child: AnimatedBuilder(
              animation: _productController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _productController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_productController),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: 10, // Replace with your product count
                      itemBuilder: (context, index) {
                        return ProductCard(
                          key: ValueKey(refreshCart),
                          name: "Product $index",
                          price: "\$${(index + 1) * 10}",
                          image: "https://www.itel-india.com/wp-content/uploads/2024/01/12-min-450x450.jpg",
                          onCartUnPressed: () {
                            _decrementCartItemCount(CartItem(
                                id: index,
                                name: "Product $index",
                                price: double.parse("${(index + 1) * 10}"),
                                quantity: 1));
                          },
                          onCartPressed: () {
                            _incrementCartItemCount(CartItem(
                                id: index,
                                name: "Product $index",
                                price: double.parse("${(index + 1) * 10}"),
                                quantity: 1));
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildCarouselImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;

  const CategoryCard({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
