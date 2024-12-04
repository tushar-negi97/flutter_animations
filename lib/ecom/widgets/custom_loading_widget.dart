import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Lottie.asset('assets/lottie/Animation1.json'),
    );
  }
}

class OrderSuccessWidget extends StatelessWidget {
  const OrderSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      // backgroundColor: Colors.white,
      content: SizedBox(
        height: 310,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Text(
              'Order Confirmed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Lottie.asset('assets/lottie/Animation5.json'),
            Positioned(
              bottom: 20,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/navigationHome');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class CommonMethods {
  static getLoadingIndicator(BuildContext cntx) {
    return showAdaptiveDialog(
        barrierDismissible: false,
        barrierColor: Colors.black38,
        context: cntx,
        builder: (cntx) => const LoadingWidget());
  }

  static getSuccessOrderDialog(BuildContext cntx) {
    return showAdaptiveDialog(context: cntx, builder: (cntx) => const OrderSuccessWidget());
  }
}
