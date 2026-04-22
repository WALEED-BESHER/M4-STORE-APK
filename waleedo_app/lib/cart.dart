import 'package:flutter/material.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
import 'constants/colors.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      p_snackbar.show(
          context: context,
          title: "حدث خطاء ما : error",
          timer: Duration(seconds: 3),
          background: color.error,
          icon: Icons.cancel,
        );
});
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Cart Page"),
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'Design System/SnackBar/primary_snackbar.dart';

// class Cart extends StatefulWidget {
//   const Cart({super.key});

//   @override
//   State<Cart> createState() => _CartState();
// }

// class _CartState extends State<Cart> {
//   @override
//   void initState() {
//     super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       behavior: SnackBarBehavior.floating,
    //       elevation: 0,
    //       backgroundColor: Colors.green,
    //       margin: EdgeInsets.zero,
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 16,
    //         vertical: 14,
    //       ),
    //       content: Row(
    //         children: [
    //           Expanded(
    //             child: Text(
    //               "تم إنشاء الحساب بنجاح",
    //               textAlign: TextAlign.right,
    //               style: const TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(width: 10),
    //           const Icon(
    //             Icons.check_circle,
    //             color: Colors.white,
    //             size: 22,
    //           ),
    //         ],
    //       ),
    //       duration: const Duration(seconds: 8),
    //     ),
    //   );
    // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("Cart Page"),

//       ),
//     );
//   }
// }