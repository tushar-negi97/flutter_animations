import 'package:bloc_app/ecom/cart_screen.dart';
import 'package:bloc_app/ecom/data.dart';
import 'package:bloc_app/ecom/product_detail_Screen.dart';
import 'package:bloc_app/ecom/widgets/animated_cart_widget.dart';
import 'package:bloc_app/ecom/widgets/animated_dialog.dart';
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
  late AnimationController _productListController;

  List<CartItem> cartItems = [];
  int cartItemCount = 0;
  bool refreshCart = false;
  bool isGrid = true;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isAddedToCart = false;

  void _incrementCartItemCount(CartItem item) {
    cartItems.add(item);
    setState(() {
      cartItemCount = cartItems.length;
    });
  }

  void _decrementCartItemCount(CartItem item) {
    if (cartItems.any((test) => test.id == item.id)) {
      var index = cartItems.indexOf(cartItems.firstWhere((test) => test.id == item.id));
      cartItems.removeAt(index);
    }
    setState(() {
      cartItemCount = cartItems.length;
    });
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
      duration: const Duration(milliseconds: 1000),
    );

    _productListController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Start animations
    _categoryController.forward();
    _productController.forward();
    _productListController.forward();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _productController.dispose();
    _productListController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // void _toggleCart(int index) {
  //   if (_isAddedToCart) {
  //     _decrementCartItemCount(
  //         CartItem(id: index, name: "Product $index", price: double.parse("${(index + 1) * 10}"), quantity: 1));

  //     _controller.reverse();
  //   } else {
  //     _controller.forward();
  //     _incrementCartItemCount(
  //         CartItem(id: index, name: "Product $index", price: double.parse("${(index + 1) * 10}"), quantity: 1));
  //   }
  //   setState(() {
  //     _isAddedToCart = !_isAddedToCart;
  //   });
  // }

  void _showProductDialog(
      BuildContext context, int index, String image, String name, String price, String description) {
    showDialog(
      context: context,
      barrierDismissible: true, // Dismiss on tap outside
      builder: (BuildContext context) {
        return Center(
          child: AnimatedDialog(
            image: image,
            name: name,
            index: index,
            price: price,
            description: description,
            onAddToCart: () {
              Navigator.pop(context); // Close the dialog
              // Add product to cart logic here
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        // backgroundColor: Colors.deepPurple,
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
        crossAxisAlignment: CrossAxisAlignment.end,
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
                height: 150,
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

          AnimatedBuilder(
              animation: _categoryController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _categoryController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_categoryController),
                    child: Container(
                      width: 100,
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: IconButton(
                                key: ValueKey(isGrid ? 'gridOn' : 'gridOff'),
                                onPressed: () {
                                  setState(() {
                                    isGrid = true;
                                  });
                                  // _categoryController.animateBack(1);
                                  _productController.reset();
                                  _productController.forward();
                                },
                                splashRadius: 1,
                                style: IconButton.styleFrom(backgroundColor: isGrid ? Colors.deepPurple : Colors.white),
                                icon: Icon(
                                  Icons.grid_on_rounded,
                                  // size: 18,
                                  color: isGrid ? Colors.white : Colors.black,
                                )),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: IconButton(
                                key: ValueKey(isGrid ? 'listOff' : 'listOn'),
                                onPressed: () {
                                  setState(() {
                                    isGrid = false;
                                  });
                                  _productListController.reset();
                                  _productListController.forward();
                                },
                                splashRadius: 1,
                                style: IconButton.styleFrom(backgroundColor: isGrid ? Colors.white : Colors.deepPurple),
                                icon: Icon(
                                  Icons.list_alt_rounded,
                                  color: isGrid ? Colors.black : Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
          // Products Section

          Expanded(
            key: ValueKey(isGrid),
            child: AnimatedBuilder(
              animation: isGrid ? _productController : _productListController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: isGrid ? _productController : _productListController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(isGrid ? _productController : _productListController),
                    child: (isGrid)
                        ? GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: MyData.productsData.length, // Replace with your product count
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  _showProductDialog(
                                    context,
                                    index,
                                    MyData.productsData[index].image,
                                    MyData.productsData[index].name,
                                    MyData.productsData[index].price,
                                    MyData.productsData[index].description,
                                  );
                                },
                                child: ProductCard(
                                  key: ValueKey(refreshCart),
                                  name: MyData.productsData[index].name,
                                  price: MyData.productsData[index].price,
                                  image: MyData.productsData[index].image,
                                  onCartUnPressed: () {
                                    _decrementCartItemCount(CartItem(
                                        id: MyData.productsData[index].id,
                                        name: MyData.productsData[index].name,
                                        price: double.parse(MyData.productsData[index].price),
                                        image: MyData.productsData[index].image,
                                        quantity: 1));
                                  },
                                  onCartPressed: () {
                                    _incrementCartItemCount(CartItem(
                                        id: MyData.productsData[index].id,
                                        name: MyData.productsData[index].name,
                                        price: double.parse(MyData.productsData[index].price),
                                        image: MyData.productsData[index].image,
                                        quantity: 1));
                                  },
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onLongPress: () {
                                  _showProductDialog(
                                    context,
                                    index,
                                    MyData.productsData[index].image,
                                    MyData.productsData[index].name,
                                    MyData.productsData[index].price,
                                    MyData.productsData[index].description,
                                  );
                                },
                                // minLeadingWidth: 150,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(
                                        name: MyData.productsData[index].name,
                                        price: MyData.productsData[index].price,
                                        image: MyData.productsData[index].image,
                                        description: MyData.productsData[index].description,
                                        productId: 'Product $index',
                                      ),
                                    ),
                                  );
                                },
                                contentPadding: const EdgeInsets.all(10),
                                leading: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Hero(
                                    tag: 'product-${"Product $index"}', // Unique tag for Hero animation
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                      child: Image.asset(
                                        MyData.productsData[index].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(MyData.productsData[index].name),
                                subtitle: Text('Price:${"\$${MyData.productsData[index].image}"}'),
                                //  trailing:
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       _toggleCart(index);
                                //     },
                                //     child: AnimatedBuilder(
                                //       animation: _rotationAnimation,
                                //       builder: (context, child) {
                                //         final angle = _rotationAnimation.value * 3.14159; // Convert to radians
                                //         return Transform(
                                //           alignment: Alignment.center,
                                //           transform: Matrix4.identity()
                                //             ..setEntry(3, 2, 0.001) // Perspective effect
                                //             ..rotateY(angle),
                                //           child: _rotationAnimation.value > 0.5
                                //               ? const Icon(
                                //                   Icons.shopping_cart,
                                //                   color: Colors.deepPurple,
                                //                   key: ValueKey('added'),
                                //                 )
                                //               : const Icon(
                                //                   Icons.shopping_cart_outlined,
                                //                   color: Colors.grey,
                                //                   key: ValueKey('notAdded'),
                                //                 ),
                                //         );
                                //       },
                                //     ),
                                //   ),
                                // ),
                              );
                            }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: Colors.deepPurple,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_offer),
      //       label: 'Offers',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shopping_cart),
      //       label: 'Cart',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      // ),
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
