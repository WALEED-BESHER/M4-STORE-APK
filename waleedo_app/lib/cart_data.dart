class CartData {

  static List<Map<String, dynamic>> cartItems = [];

  // منتج مخصص
  static String customProduct = "";

  // القسيمة
  static String couponCode = "";
  static bool couponApplied = false;
  static double discountAmount = 0;

  // ملاحظة الطلب 
  static String orderNote = "";

  // الدفع
  static String selectedPayment = "عند الاستلام";

  // بيانات الحوالة 
  static String networkName = "";
  static String transferNumber = "";

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
