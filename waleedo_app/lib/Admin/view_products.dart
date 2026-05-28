import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../Design System/AppBar/primary_appbar.dart';
import '../product_service.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({super.key});

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  // قائمة المنتجات
  List<Map<String, dynamic>> products = [];
  // حالة التحميل
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // دالة تحميل المنتجات
  Future<void> _loadProducts() async {
    setState(() => isLoading = true);
    try {
      final loadedProducts = await ProductService.getProducts();
      setState(() {
        products = loadedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل المنتجات: $e')),
        );
      }
    }
  }

  // دالة حذف المنتج (ستنشئها في السيرفس لاحقاً)
  Future<void> _deleteProduct(int productId) async {
    // سيتم إضافة كود الحذف هنا
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: color.dark2,
        title: Center(
          child: Text(
            'تأكيد الحذف',
            style: fonts.lb.copyWith(color: color.white),
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا المنتج؟',
          style: fonts.ss.copyWith(color: color.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: fonts.sb.copyWith(color: color.g600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // هنا ستضيف استدعاء API الحذف
              _loadProducts(); // إعادة تحميل القائمة
            },
            child: Text(
              'حذف',
              style: fonts.sb.copyWith(color: color.error),
            ),
          ),
        ],
      ),
    );
  }

  // دالة تعديل المنتج
  void _editProduct(Map<String, dynamic> product) {
    // هنا ستنتقل لصفحة التعديل
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تعديل المنتج: ${product['title']}')),
    );
  }

  // بناء جدول المنتجات
  Widget _buildProductsTable() {
    return SingleChildScrollView(
      // تمرير أفقي
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        // تمرير عمودي
        scrollDirection: Axis.vertical,
        child: DataTable(
          // خصائص الجدول
          columnSpacing: 20,
          headingRowHeight: 60,
          dataRowHeight: 80,
          horizontalMargin: 15,
          
          // رأس الجدول
          columns: _buildColumns(),
          
          // صفوف البيانات
          rows: _buildRows(),
        ),
      ),
    );
  }

  // بناء أعمدة الجدول
  List<DataColumn> _buildColumns() {
    // قائمة عناوين الأعمدة
    final headers = [
      'Id', 'Title', 'newPrice', 'oldPrice', 'Description',
      'caliber', 'capacity', 'category', 'ProductType', 'ProductType2',
      'length', 'model', 'weight', 'manufacturing_countrey',
      'manufacturing_company', 'usage', 'date', 'rating',
      'bestOffer', 'Type', 'العمليات'
    ];

    return headers.map((header) {
      return DataColumn(
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            header,
            style: fonts.lb.copyWith(color: color.white),
            textAlign: TextAlign.center,
          ),
        ),
        numeric: header == 'Id' || header == 'newPrice' || 
                header == 'oldPrice' || header == 'rating',
      );
    }).toList();
  }

  // بناء صفوف البيانات
  List<DataRow> _buildRows() {
    return products.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;
      
      return DataRow(
        // تلوين الصفوف بالتناوب
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.teal.withOpacity(0.2);
            }
            return index.isEven 
                ? color.white.withOpacity(0.2) 
                : color.b_activered;
          },
        ),
        
        cells: [
          DataCell(
            Center(
              child: Text(
                product['id']?.toString() ?? '',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Directionality(
                textDirection: TextDirection.rtl, 
                child: Text(
                  product['title'] ?? '',
                  style: fonts.ss.copyWith(color: color.g400),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['newPrice']?.toString() ?? '0',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['oldPrice']?.toString() ?? '0',
                style: fonts.ms.copyWith(color: color.p500),
              ),
            ),
          ),

          DataCell(
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl, 
                  child: Text(
                    product['Description'] ?? '',
                    style: fonts.ss.copyWith(color: color.g400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          ),
          
          DataCell(
            Center(
              child: Text(
                product['caliber'] ?? '',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),


          DataCell(
            Center(
              child: Text(
                product['capacity'] ?? '',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),
          
          DataCell(
            Center(
              child: Text(
                product['category'] ?? '',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['ProductType'] ?? '',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['ProductType2'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['length'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['model'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['weight'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['manufacturing_countrey'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['manufacturing_company'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['usage'] == 1 || product['usage'] == true ? 'مستعمل' : 'جديد',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['date'] ?? '-',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['rating']?.toString() ?? '0',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['bestOffer'] == 1 || product['bestOffer'] == true ? 'نعم' : 'لا',
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['type'] == "full" ? " الكل ظاهر" : product['type'] == "hideBoth" ? "الكل مخفي" : product['type'] == "hideOldPrice" ? "السعر القديم مخفي" : product['type'] == "hideDiscount" ? "نسبه الخصم مخفيه" : "الكل ظاهر" ,
                style: fonts.ss.copyWith(color: color.g400),
              ),
            ),
          ),

          
          // خلية العمليات
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر التعديل
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editProduct(product),
                  tooltip: 'تعديل',
                  iconSize: 20,
                ),
                const SizedBox(width: 5),
                // زر الحذف
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(product['id']),
                  tooltip: 'حذف',
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "عرض المنتجات",
        centerTheTitles: true,
      ),


      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('لا توجد منتجات'))
              : _buildProductsTable(),

    );
  }

}
