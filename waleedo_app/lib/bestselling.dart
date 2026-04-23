import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'Design System/ProductCard/product_card.dart';
import 'Design System/AppBar/primary_appbar.dart';

class Bestselling extends StatefulWidget {
  const Bestselling({super.key});

  @override
  State<Bestselling> createState() => _BestsellingState();
}

class _BestsellingState extends State<Bestselling> {
  // قاىمه المنتجات المعروضه في الاكثر مبيعا
  final List<Map<String, dynamic>> BestSelling = [
    {
      "id": 1,
      "image": "assets/images/Mosher.jpg",
      "title": " مشير جديد زيرو",
      "newPrice": 1866,
      "oldPrice": 2133,
    },
    {
      "id": 2,
      "image": "assets/images/Motamarn.jpg",
      "title": "موتمر نيكل جديد بلقرطاس",
      "newPrice": 3200,
      "oldPrice": 3733,
      "type": ProductCardType.hideBoth,
    },
    {
      "id": 3,
      "image": "assets/images/M41.jpg",
      "title": "ام فور امريكي درجه اولى مع التوابع جديد ووكاله ما قد ضرب",
      "newPrice": 5000,
      "oldPrice": 5700,
    },
    {
      "id": 4,
      "image": "assets/images/Glock.jpg",
      "title": "كلوك نمساوي درجه اولى",
      "newPrice": 2800,
      "oldPrice": 3500,
      "type": ProductCardType.hideOldPrice
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "الاكثر مبيعاً",
        showLeading: true,
        btn1_Onprss: () {
          
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Directionality(
          textDirection: TextDirection.rtl, 
          child: GridView.builder(
            itemCount: BestSelling.length, // عدد المنتجات (غيره حسب بياناتك)
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // ⭐ كل صف فيه 2
              crossAxisSpacing: 6, // مسافة بين الأعمدة
              mainAxisSpacing: 8, // مسافة بين الصفوف
              childAspectRatio: 0.70, // ⭐ يتحكم في طول الكرت
            ),
            itemBuilder: (context, index){
              final product = BestSelling[index];

              return Directionality(
                textDirection: TextDirection.ltr, 
                child: ProductCard(
                  id: product["id"],
                  image: product["image"],
                  title: product["title"],
                  newPrice: product["newPrice"],
                  oldPrice: product["oldPrice"],
                  type: product["type"] ?? ProductCardType.full,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}




// important

// import 'package:flutter/material.dart';
// import 'constants/colors.dart';
// import 'Design System/ProductCard/product_card.dart';
// import 'Design System/AppBar/primary_appbar.dart';

// class Bestselling extends StatefulWidget {
//   const Bestselling({super.key});

//   @override
//   State<Bestselling> createState() => _BestsellingState();
// }

// class _BestsellingState extends State<Bestselling> {
//   final List<Map<String, dynamic>> BestSelling = [
//     {
//       "id": 1,
//       "image": "assets/images/Mosher.jpg",
//       "title": "مشير جديد زيرو",
//       "newPrice": 1866,
//       "oldPrice": 2133,
//     },
//     {
//       "id": 2,
//       "image": "assets/images/Motamarn.jpg",
//       "title": "موتمر نيكل جديد",
//       "newPrice": 3200,
//       "oldPrice": 3733,
//       "type": ProductCardType.hideBoth,
//     },
//     {
//       "id": 3,
//       "image": "assets/images/M41.jpg",
//       "title": "ام فور امريكي",
//       "newPrice": 5000,
//       "oldPrice": 5700,
//     },
//     {
//       "id": 4,
//       "image": "assets/images/Glock.jpg",
//       "title": "كلوك نمساوي",
//       "newPrice": 2800,
//       "oldPrice": 3500,
//       "type": ProductCardType.hideOldPrice,
//     },
//   ];

//   int sortValue = 0;
//   int priceValue = 0;
//   int useValue = 0;

//   // ===============================
//   // شاشة الفلترة
//   // ===============================
//   void showFilterSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.82,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: color.dark1,
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(22),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // الخط الصغير فوق
//                   Container(
//                     width: 50,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // العنوان
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.arrow_back,
//                             color: Colors.white),
//                       ),
//                       const Spacer(),
//                       const Text(
//                         "فلترة",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           filterBox(
//                             title: "فرز حسب",
//                             child: Column(
//                               children: [
//                                 radioTile("موصى به", 1, sortValue,
//                                     (v) => setModalState(() => sortValue = v!)),
//                                 radioTile("الأكثر شيوعاً", 2, sortValue,
//                                     (v) => setModalState(() => sortValue = v!)),
//                                 radioTile("الأحدث", 3, sortValue,
//                                     (v) => setModalState(() => sortValue = v!)),
//                                 radioTile("الأقدم", 4, sortValue,
//                                     (v) => setModalState(() => sortValue = v!)),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           filterBox(
//                             title: "فلترة حسب السعر",
//                             child: Column(
//                               children: [
//                                 radioTile("الأغلى", 1, priceValue,
//                                     (v) => setModalState(() => priceValue = v!)),
//                                 radioTile("الأرخص", 2, priceValue,
//                                     (v) => setModalState(() => priceValue = v!)),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           filterBox(
//                             title: "فلترة حسب الاستخدام",
//                             child: Column(
//                               children: [
//                                 radioTile("جديد", 1, useValue,
//                                     (v) => setModalState(() => useValue = v!)),
//                                 radioTile("مستخدم", 2, useValue,
//                                     (v) => setModalState(() => useValue = v!)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // الأزرار
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             setModalState(() {
//                               sortValue = 0;
//                               priceValue = 0;
//                               useValue = 0;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey.shade800,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                           ),
//                           child: const Text(
//                             "إعادة تعيين",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 10),

//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                           ),
//                           child: const Text(
//                             "تطبيق",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ===============================
//   // صندوق الفلترة
//   // ===============================
//   Widget filterBox({required String title, required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: color.dark2,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 19,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Divider(color: Colors.white24),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget radioTile(
//     String title,
//     int value,
//     int groupValue,
//     Function(int?) onChanged,
//   ) {
//     return RadioListTile(
//       activeColor: Colors.red,
//       value: value,
//       groupValue: groupValue,
//       onChanged: onChanged,
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white),
//         textAlign: TextAlign.right,
//       ),
//       controlAffinity: ListTileControlAffinity.trailing,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color.dark1,
//       appBar: p_appbar(
//         title: "الاكثر مبيعاً",
//         showLeading: true,
//         btn1_Onprss: () {
//           showFilterSheet();
//         },
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//         child: GridView.builder(
//           itemCount: BestSelling.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 6,
//             mainAxisSpacing: 8,
//             childAspectRatio: 0.70,
//           ),
//           itemBuilder: (context, index) {
//             final product = BestSelling[index];

//             return ProductCard(
//               id: product["id"],
//               image: product["image"],
//               title: product["title"],
//               newPrice: product["newPrice"],
//               oldPrice: product["oldPrice"],
//               type: product["type"] ?? ProductCardType.full,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
















// import 'package:flutter/material.dart';
// import 'constants/colors.dart';
// import 'Design System/ProductCard/product_card.dart';
// import 'Design System/AppBar/primary_appbar.dart';

// class Bestselling extends StatefulWidget {
//   const Bestselling({super.key});

//   @override
//   State<Bestselling> createState() => _BestsellingState();
// }

// class _BestsellingState extends State<Bestselling> {

//   // ⭐ القائمة الأصلية (لا نلمسها)
//   final List<Map<String, dynamic>> BestSelling = [
//     {
//       "id": 1,
//       "image": "assets/images/Mosher.jpg",
//       "title": " مشير جديد زيرو",
//       "newPrice": 1866,
//       "oldPrice": 2133,
//     },
//     {
//       "id": 2,
//       "image": "assets/images/Motamarn.jpg",
//       "title": "موتمر نيكل جديد بلقرطاس",
//       "newPrice": 3200,
//       "oldPrice": 3733,
//       "type": ProductCardType.hideBoth,
//     },
//     {
//       "id": 3,
//       "image": "assets/images/M41.jpg",
//       "title": "ام فور امريكي درجه اولى",
//       "newPrice": 5000,
//       "oldPrice": 5700,
//     },
//     {
//       "id": 4,
//       "image": "assets/images/Glock.jpg",
//       "title": "كلوك نمساوي درجه اولى",
//       "newPrice": 2800,
//       "oldPrice": 3500,
//       "type": ProductCardType.hideOldPrice
//     },
//   ];

//   // ⭐ القائمة الجديدة (اللي نعرضها)
//   List<Map<String, dynamic>> filteredList = [];

//   // ⭐ اختيار واحد فقط لكل الراديو
//   String selectedFilter = "";

//   @override
//   void initState() {
//     super.initState();
//     filteredList = List.from(BestSelling);
//   }

//   // ⭐ فتح شاشة الفلترة
//   void openFilter() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: color.dark2,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateSheet) {
//             return Container(
//               padding: const EdgeInsets.all(16),
//               height: MediaQuery.of(context).size.height * 0.85,
//               child: Column(
//                 children: [

//                   // 🔹 الهيدر
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const SizedBox(),
//                       const Text("فلترة", style: TextStyle(fontSize: 18, color: Colors.white)),
//                       IconButton(
//                         icon: const Icon(Icons.arrow_forward, color: Colors.white),
//                         onPressed: () => Navigator.pop(context),
//                       )
//                     ],
//                   ),

//                   const SizedBox(height: 10),

//                   Expanded(
//                     child: ListView(
//                       children: [

//                         // 🔹 فرز حسب
//                         buildSection(
//                           title: "فرز حسب",
//                           children: [
//                             radioItem("موصى به", setStateSheet),
//                             radioItem("الأكثر شيوعاً", setStateSheet),
//                             radioItem("الأحدث", setStateSheet),
//                             radioItem("الأقدم", setStateSheet),
//                           ],
//                         ),

//                         // 🔹 السعر
//                         buildSection(
//                           title: "فلترة حسب السعر",
//                           children: [
//                             radioItem("الأعلى", setStateSheet),
//                             radioItem("الأرخص", setStateSheet),
//                           ],
//                         ),

//                         // 🔹 الاستخدام
//                         buildSection(
//                           title: "فلترة حسب الاستخدام",
//                           children: [
//                             radioItem("جديد", setStateSheet),
//                             radioItem("مستخدم", setStateSheet),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // 🔻 الأزرار
//                   Row(
//                     children: [

//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey[800],
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               selectedFilter = "";
//                               filteredList = List.from(BestSelling);
//                             });
//                             Navigator.pop(context);
//                           },
//                           child: const Text("إعادة تعيين"),
//                         ),
//                       ),

//                       const SizedBox(width: 10),

//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                           onPressed: () {
//                             applyFilter();
//                             Navigator.pop(context);
//                           },
//                           child: const Text("تطبيق"),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ⭐ عنصر radio
//   Widget radioItem(String value, Function setStateSheet) {
//     return RadioListTile(
//       title: Text(value, style: const TextStyle(color: Colors.white)),
//       value: value,
//       groupValue: selectedFilter,
//       activeColor: Colors.red,
//       onChanged: (val) {
//         setState(() {
//           selectedFilter = val.toString();
//         });
//         setStateSheet(() {});
//       },
//     );
//   }

//   // ⭐ تصميم القسم
//   Widget buildSection({required String title, required List<Widget> children}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.dark1,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(color: Colors.white)),
//           const Divider(),
//           ...children
//         ],
//       ),
//     );
//   }

//   // ⭐ تطبيق الفلترة
//   void applyFilter() {
//     List<Map<String, dynamic>> temp = List.from(BestSelling);

//     if (selectedFilter == "الأعلى") {
//       temp.sort((a, b) => b["newPrice"].compareTo(a["newPrice"]));
//     } else if (selectedFilter == "الأرخص") {
//       temp.sort((a, b) => a["newPrice"].compareTo(b["newPrice"]));
//     }

//     setState(() {
//       filteredList = temp;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color.dark1,
//       appBar: p_appbar(
//         title: "الاكثر مبيعاً",
//         showLeading: true,
//         btn1_Onprss: openFilter, // ⭐ هنا فتح الفلتر
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//         child: GridView.builder(
//           itemCount: filteredList.length, // ⭐ استخدمنا الجديدة
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 6,
//             mainAxisSpacing: 8,
//             childAspectRatio: 0.70,
//           ),
//           itemBuilder: (context, index) {
//             final product = filteredList[index];

//             return ProductCard(
//               id: product["id"],
//               image: product["image"],
//               title: product["title"],
//               newPrice: product["newPrice"],
//               oldPrice: product["oldPrice"],
//               type: product["type"] ?? ProductCardType.full,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }