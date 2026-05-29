import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../Design System/AppBar/primary_appbar.dart';
import '../product_service.dart';
import '../Design System/SnackBar/primary_snackbar.dart';

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

        p_snackbar.show(
          context: context,
          title: 'خطأ في تحميل المنتجات: $e',
          timer: Duration(seconds: 3),
          background: color.error,
          icon: Icons.cancel,
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
        content: SizedBox(
          height: 18,
          child: Center(
            child: Text(
              'هل أنت متأكد من حذف هذا المنتج؟',
              style: fonts.ss.copyWith(color: color.white),
            ),
          ),
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
            onPressed: () async {
              
              final success =
                  await ProductService.deleteProduct(
                productId,
              );
              if (success) {
                p_snackbar.show(
                  context: context,
                  title: 'تم حذف المنتج بنجاح',
                  timer: Duration(seconds: 3),
                );

                
                Navigator.pop(context);
                _loadProducts();
              } else {
                p_snackbar.show(
                  context: context,
                  title: 'فشل حذف المنتج',
                  timer: Duration(seconds: 3),
                  background: color.error,
                  icon: Icons.cancel,
                );
                
              }
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        // تمرير أفقي
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          // تمرير عمودي
          scrollDirection: Axis.vertical,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(color.f_secondary),
            dividerThickness: 0,
            border: TableBorder(
              horizontalInside: BorderSide(
                color: color.g400,
                width: 2
              )
            ),
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
      ),
    );
  }

  // بناء أعمدة الجدول
  List<DataColumn> _buildColumns() {
    // قائمة عناوين الأعمدة
    final headers = [
      'ID', 'العنوان', 'السعر الجديد', 'السعر القديم', 'الوصف',
      'العيار', 'السعه', 'الفئه', 'نوع السلاح', 'نوع السلاح2',
      'الطول', 'المودل ', 'الوزن', 'الدولة المصنعة',
      'الشركة المصنعة', 'الاستخدام', 'انباعت' ,'وقت الاضافه', 'التقيم',
      'افضل العروض', 'النوع', 'العمليات'
    ];

    return headers.map((header) {
      double? maxWidth;
      if(header == 'العنوان'){
        maxWidth = 150;
      }else if(header == 'الوصف'){
        maxWidth = 250;
      }else if(header == 'النوع' || header == 'العمليات' ){
        maxWidth = 100;
      }

      return DataColumn(
        label: ConstrainedBox(
          constraints: maxWidth != null 
          ? BoxConstraints(maxWidth: maxWidth) : BoxConstraints(),
          child:  Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.center,
            child: Text(
              header,
              style: fonts.mb.copyWith(color: color.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
            return index.isEven 
                ? Colors.transparent
                : color.b_activered;
          },
        ),
        
        cells: [
          DataCell(
            Center(
              child: Text(
                product['id']?.toString() ?? '',
                style: fonts.ss.copyWith(color: color.g200),
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
                  style: fonts.ss.copyWith(color: color.g200),
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
                style: fonts.ss.copyWith(color: color.g200),
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
                    style: fonts.ss.copyWith(color: color.g200),
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
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),


          DataCell(
            Center(
              child: Text(
                product['capacity'] ?? '',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),
          
          DataCell(
            Center(
              child: Text(
                product['category'] ?? '',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['ProductType'] ?? '',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['ProductType2'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['length'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['model'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['weight'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),  
        
          DataCell(
            Center(
              child: Text(
                product['manufacturing_countrey'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          
          DataCell(
            Center(
              child: Text(
                product['manufacturing_company'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['usage'] == 1 || product['usage'] == true ? 'مستعمل' : 'جديد',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['sold'].toString() ,
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Container(
                alignment: Alignment.center,
                child: Directionality(
                  textDirection: TextDirection.rtl, 
                  child: Text(
                    product['date'].toString().replaceAll('T', ' ').split('.').first,
                    style: fonts.ss.copyWith(color: color.g200),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ),
          
          DataCell(
            Center(
              child: Text(
                product['rating']?.toString() ?? '0',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['bestOffer'] == 1 || product['bestOffer'] == true ? 'نعم' : 'لا',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                product['type'] == "full" ? " الكل ظاهر" : product['type'] == "hideBoth" ? "الكل مخفي" : product['type'] == "hideOldPrice" ? "السعر القديم مخفي" : product['type'] == "hideDiscount" ? "نسبه الخصم مخفيه" : "الكل ظاهر" ,
                style: fonts.ss.copyWith(color: color.g200),
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
