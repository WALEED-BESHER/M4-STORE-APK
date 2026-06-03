import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../Design System/Buttons/primary_button.dart';
import '../Design System/AppBar/primary_appbar.dart';
import 'user_service.dart';
import '../Design System/SnackBar/primary_snackbar.dart';

class UserManagment extends StatefulWidget {
  const UserManagment({super.key});

  @override
  State<UserManagment> createState() => _UserManagmentState();
}

class _UserManagmentState extends State<UserManagment> {
  

  // قائمة المستخدمين
  List<Map<String, dynamic>> users = [];

  // حالة التحميل
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // جلب اليوزرات
  Future<void> _loadUsers() async {
    setState(() => isLoading = true);
    try {
      final loadedUsers = await UserService.getUsers();
      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {

        p_snackbar.show(
          context: context,
          title: 'خطأ في تحميل اليوزرات: $e',
          timer: Duration(seconds: 3),
          background: color.error,
          icon: Icons.cancel,
        );

      }
    }
  }

  // activeation
  Future<void> _toggleActivation(int userId,) async {
    final result = await UserService.toggleActivation(userId,);
    if(result["success"]){
      p_snackbar.show(
        context: context,
        title: result["message"],
        timer: const Duration(seconds: 3),
        background: color.success,
      );
      _loadUsers();
    }else{
      p_snackbar.show(
        context: context,
        title: result["message"],
        timer: const Duration(seconds: 3),
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }
 
  Future<void> activateAccount(int userId,dynamic activation,) async {
    final bool isActive =activation == 1 || activation == true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: color.dark2,
        title: Center(
          child: Text(
            isActive
                ? 'تأكيد التعطيل'
                : 'تأكيد التفعيل',
            style: fonts.lb.copyWith(
              color: color.white,
            ),
          ),
        ),
        content: SizedBox(
          height: 18,
          child: Center(
            child: Text(
              isActive
                  ? 'هل أنت متأكد من تعطيل هذا الحساب؟'
                  : 'هل أنت متأكد من تفعيل هذا الحساب؟',
              style: fonts.ss.copyWith(
                color: color.white,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: fonts.sb.copyWith(
                color: color.g600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _toggleActivation(
                userId,
              );
            },
            child: Text(
              isActive
                  ? 'تعطيل'
                  : 'تفعيل',
              style: fonts.sb.copyWith(
                color: isActive
                    ? color.error
                    : color.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // رفع وسحب الادمن
  Future<void> _toggleAdmin(int userId,) async {
    final result = await UserService.toggleAdmin(userId,);
    if(result["success"]){
      p_snackbar.show(
        context: context,
        title: result["message"],
        timer: const Duration(seconds: 3),
        background: color.success,
      );
      _loadUsers();
    }else{
      p_snackbar.show(
        context: context,
        title: result["message"],
        timer: const Duration(seconds: 3),
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }
 
  Future<void> Admin(int userId,dynamic admin,) async {
    final bool isAdmin = admin == 1 || admin == true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: color.dark2,
        title: Center(
          child: Text(
            isAdmin
                ? 'تأكيد سحب الاشراف'
                : 'تأكيد رفع الاشراف',
            style: fonts.lb.copyWith(
              color: color.white,
            ),
          ),
        ),
        content: SizedBox(
          height: 18,
          child: Center(
            child: Text(
              isAdmin
                  ? "هل أنت متأكد من سحب صلاحية الأدمن؟"
                  : "هل أنت متأكد من رفع المستخدم إلى أدمن؟",
              style: fonts.ss.copyWith(
                color: color.white,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: fonts.sb.copyWith(
                color: color.g600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _toggleAdmin(
                userId,
              );
            },
            child: Text(
              isAdmin
                  ? 'سحب الادمن'
                  : 'رفع ادمن',
              style: fonts.sb.copyWith(
                color: isAdmin
                    ? color.error
                    : color.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // حذف المستخدم من dashboard
  Future<void> _deleteUser(int userId) async {
    final result =
        await UserService.deleteUser(
      userId,
    );
    if(result["success"]){
      p_snackbar.show(
        context: context,
        title: result["message"],
        timer: const Duration(seconds: 3),
        background: color.success,
      );
      _loadUsers();
    }else{
      p_snackbar.show(
        context: context,
        title: result["message"],
        timer: const Duration(seconds: 3),
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }

  Future<void> DeleteUser(int userId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: color.dark2,
        title: Center(
          child: Text(
            'تأكيد الحذف',
            style: fonts.lb.copyWith(
              color: color.white,
            ),
          ),
        ),
        content: SizedBox(
          height: 18,
          child: Center(
            child: Text(
              'هل أنت متأكد من حذف هذا المستخدم؟',
              style: fonts.ss.copyWith(
                color: color.white,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: fonts.sb.copyWith(
                color: color.g600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteUser(
                userId,
              );
            },
            child: Text(
              'حذف',
              style: fonts.sb.copyWith(
                color:color.error,
              ),
            ),
          ),
        ],
      ),
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
            dataRowHeight: 145,
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
      'ID', 'الاسم الاول', 'الاسم الاخر', 'الايميل', 'رقم الجوال',
      'رقم الجوال2', 'الرتبة', 'التحقق', 'التفعيل', 'العمليات'
    ];

    return headers.map((header) {
      double? maxWidth;
      if(header == 'الايميل'){
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
    return users.asMap().entries.map((entry) {
      final index = entry.key;
      final users = entry.value;
      
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
                users["id"]?.toString() ?? '',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),
          
          DataCell(
            Center(
              child: Text(
                users['first_name'] ?? '-',
                style: fonts.ss.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                users['last_name'] ?? '-',
                style: fonts.ms.copyWith(color: color.g200),
              ),
            ),
          ),

          DataCell(
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Directionality(
                textDirection: TextDirection.rtl, 
                child: Text(
                  users['email'] ?? '-',
                  style: fonts.ms.copyWith(color: color.g200),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ),

          
          DataCell(
            Center(
              child: Text(
                users['phone_number'] ?? '-',
                style: fonts.ms.copyWith(color: color.g200),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                users['phone_number2'] ?? '-',
                style: fonts.ms.copyWith(color: color.g200),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                users['admin']  == 1 || users['admin']  == true ? "ادمن" : "مستخدم عادي",
                style: fonts.ms.copyWith(color: users['admin']  == 1 || users['admin']  == true ? color.error :color.g200),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                users['verification']  == 1 || users['verification']  == true ? "تم التحقق" : "لم يتم التحقق",
                style: fonts.ms.copyWith(color:  users['verification']  == 1 || users['verification']  == true ? color.g200 : color.error),
              ),
            ),
          ),

          DataCell(
            Center(
              child: Text(
                users['activation']  == 1 || users['activation']  == true ? "تم التفعيل" : "لم يتم تفعيل الحساب",
                style: fonts.ms.copyWith(color:  users['activation']  == 1 || users['activation']  == true ? color.g200 : color.error),
              ),
            ),
          ),

          
          // خلية العمليات
          DataCell(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // حظر الحسابات
                p_button(
                  title: users['activation']  == 1 || users['activation']  == true ?  "تعطيل الحساب" : "تفعيل الحساب", 
                  onPressed: () => activateAccount(users['id'],users['activation']),
                  background: users['activation']  == 1 || users['activation']  == true ? color.error : color.success,
                ),
                // ادمن
                p_button(
                  title: users['admin']  == 1 || users['admin']  == true ?  "سحب الادمن" : "رفع ادمن", 
                  onPressed: () => Admin(users['id'],users['admin']),
                  background: users['admin']  == 1 || users['admin']  == true ? color.error : color.success,
                ),
                // حذف 
                p_button(
                  title: "حذف", 
                  onPressed: () => DeleteUser(users['id']),
                  showRightIcon: true,
                  rightIcon: Icons.delete,
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
        title: "عرض اليوزرات",
        centerTheTitles: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ?  Center(child: Text('لا توجد مستخدمين',style: fonts.h3.copyWith(color: color.white),))
              : _buildProductsTable(),

    );
  }
}