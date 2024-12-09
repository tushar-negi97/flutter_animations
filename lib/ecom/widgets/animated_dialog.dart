import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  final String image;
  final String name;
  final int index;
  final String price;
  final String description;
  final VoidCallback onAddToCart;

  const AnimatedDialog({
    Key? key,
    required this.image,
    required this.index,
    required this.name,
    required this.price,
    required this.description,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closeDialog() async {
    await _controller.reverse(); // Play reverse animation
    if (mounted) {
      Navigator.of(context).pop(); // Dismiss the dialog after animation completes
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.all(0),
        title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: _closeDialog,
                style: IconButton.styleFrom(backgroundColor: Colors.deepPurple),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ))),
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Hero(
                    tag: 'product-${"Product ${widget.index}"}',
                    child: Image.asset(widget.image, height: 150, fit: BoxFit.cover)),
              ),
              const SizedBox(height: 10),
              Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                widget.price,
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: widget.onAddToCart,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.deepPurple,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   ),
              //   child: const Text("Add to Cart"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
