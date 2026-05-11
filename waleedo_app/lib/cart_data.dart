class CartData {

  static List<Map<String, dynamic>> cartItems = [];

  // إضافة أو تحديث منتج
  static void setProduct(Map<String, dynamic> product, int quantity) {

    int index = cartItems.indexWhere(
      (item) => item["id"] == product["id"],
    );

    if (index != -1) {

      // تحديث الكمية فقط
      cartItems[index]["quantity"] = quantity;

    } else {

      // إضافة جديدة
      cartItems.add({
        ...product,
        "quantity": quantity,
      });

    }
  }

  // جلب منتج
  static Map<String, dynamic>? getProduct(int id) {

    try {

      return cartItems.firstWhere(
        (item) => item["id"] == id,
      );

    } catch (e) {

      return null;

    }
  }

  // حذف
  static void removeFromCart(int id) {

    cartItems.removeWhere(
      (item) => item["id"] == id,
    );

  }
}


// class CartData {

//   // المنتجات داخل السلة
//   static List<Map<String, dynamic>> cartItems = [];

//   // إضافة منتج
//   static void addToCart(Map<String, dynamic> product, int quantity) {

//     // هل المنتج موجود مسبقاً؟
//     int index = cartItems.indexWhere(
//       (item) => item["id"] == product["id"],
//     );

//     if (index != -1) {

//       // إذا موجود زيد الكمية
//       cartItems[index]["quantity"] += quantity;

//     } else {

//       // إذا غير موجود أضفه
//       cartItems.add({
//         ...product,
//         "quantity": quantity,
//       });

//     }
//   }

//   // حذف منتج
//   static void removeFromCart(int id) {
//     cartItems.removeWhere((item) => item["id"] == id);
//   }
// }