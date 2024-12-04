import 'package:bloc_app/ecom/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MaterialApp(home: CartScreen()));
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  List<CartItem> cartItems = [
    // CartItem(id: 0, name: "Product 1", price: 20.0, quantity: 1),
    // CartItem(id: 1, name: "Product 2", price: 30.0, quantity: 1),
    // CartItem(id: 2, name: "Product 3", price: 40.0, quantity: 1),
    // CartItem(id: 3, name: "Product 5", price: 40.0, quantity: 1),
  ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    // Delay to show items with animation on load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        setState(() {
          cartItems = ModalRoute.of(context)!.settings.arguments as List<CartItem>;
        });
      }
      await Future.delayed(const Duration(milliseconds: 100));
      for (int i = 0; i < cartItems.length; i++) {
        Future.delayed(Duration(milliseconds: i * 250), () {
          _listKey.currentState?.insertItem(i);
        });
      }
    });
  }

  // Remove item with slide and fade animation
  void _removeItem(int index) async {
    //CommonMethods.getLoadingIndicator(context);
    // await Future.delayed(Duration(seconds: 4));
    // Navigator.pop(context);
    final removedItem = cartItems[index];
    setState(() {
      cartItems.removeAt(index);
    });

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: animation.drive(
          Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
        ),
        child: SizeTransition(
          sizeFactor: animation,
          child: _buildCartItemCard(removedItem, null),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(cartItems);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? Column(
              children: [
                const Spacer(),
                Lottie.asset('assets/lottie/Animation6.json'),
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.popAndPushNamed(context, '/navigationHome');
                //     },
                //     style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                //     child: const Text(
                //       'Shop Now',
                //       style: TextStyle(color: Colors.white),
                //     )),
                const Text('No Products in Cart'),
                const Spacer(flex: 3),
              ],
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: 0, // Items are added dynamically with animation
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: _buildCartItemCard(cartItems[index], () => _removeItem(index)),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () async {
                  CommonMethods.getLoadingIndicator(context);
                  await Future.delayed(Duration(seconds: 3));
                  Navigator.of(context).pop();
                  CommonMethods.getSuccessOrderDialog(context);

                  // Placeholder for "Proceed to Pay"
                },
                child: const Text(
                  "Proceed to Pay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCartItemCard(CartItem item, VoidCallback? onDelete) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://www.itel-india.com/wp-content/uploads/2024/01/12-min-450x450.jpg",
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("\$${item.price.toStringAsFixed(2)}"),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Qty: "),
                      Text(item.quantity.toString()),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem {
  final String name;
  final int id;
  final double price;
  final int quantity;

  CartItem({required this.name, required this.id, required this.price, required this.quantity});
}
