import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../Design System/AppBar/primary_appbar.dart';
import '../Design System/Buttons/primary_button.dart';

class addProducts extends StatefulWidget {
  const addProducts({super.key});

  @override
  State<addProducts> createState() => _addProductsState();
}

class _addProductsState extends State<addProducts> {
  final ImagePicker _picker = ImagePicker();

  List<XFile> images = [];

  final titleController = TextEditingController();
  final oldPriceController = TextEditingController();
  final newPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final caliberController = TextEditingController();
  final capacityController = TextEditingController();
  final productTypeController = TextEditingController();
  final productType2Controller = TextEditingController();
  final modelController = TextEditingController();
  final weightController = TextEditingController();
  final manufacturingCountryController = TextEditingController();
  final manufacturingCompanyController = TextEditingController();
  final ratingController = TextEditingController();

  String? selectedCategory;

  bool usage = true;
  bool bestOffer = false;

  final List<String> categories = [
    "بنادق",
    "مسدسات",
    "قناصات",
    "قنابل",
    "ذخاير",
  ];

  Future<void> pickImages() async {
    final pickedImages = await _picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        images = pickedImages;
      });
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget Productsinputs(
    String hint, 
    int maxLines,
    TextEditingController control,
    {
      TextInputType keyboardType = TextInputType.text,
      int ? minlines,
    }
  ){
    return Container(
      padding:EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.dark2,
        borderRadius:BorderRadius.circular(12),
        border: Border.all(
          color: color.g500,
        ),
      ),
      child: TextFormField(
        controller: control,
        style: fonts.ss.copyWith(
          color: color.white,
        ),
        keyboardType: keyboardType,
        cursorColor: color.p500,
        textAlign: TextAlign.right,
        textDirection:  TextDirection.rtl,
        maxLines: maxLines,
        minLines: minlines,
        decoration: InputDecoration(
          // isCollapsed: true,
          hintText: hint,
          hintStyle: fonts.sb.copyWith(
            color: color.g500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "اضافه منتجات جديده" ,
        centerTheTitles: true,
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            /// Images
            Text(
              "صور المنتج",
              style: fonts.mb.copyWith(color: color.white),
            ),
           
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImages,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: color.g500),
                  borderRadius: BorderRadius.circular(12),
                  color: color.dark2
                ),
                child: images.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: color.g500,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(images[index].path),
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Title  
            Productsinputs(
              "عنوان المنتج",
              4,
              titleController,
            ),

            const SizedBox(height: 12),

            // Prices
            Row(
              children: [
                Expanded(
                  child: Productsinputs(
                    "السعر القديم", 
                    1, 
                    oldPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Productsinputs(
                    "السعر الجديد", 
                    1, 
                    newPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Productsinputs(
              "الوصف", 
              6, 
              descriptionController 
            ),

            const SizedBox(height: 12),

            Productsinputs(
              "العيار", 
              1, 
              caliberController,
            ),

            const SizedBox(height: 12),

            Productsinputs(
              "سعه السلاح", 
              1, 
              capacityController,
            ),

            const SizedBox(height: 12),

            // Category
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: color.dark2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.g500,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  isDense: true,
                  alignment: Alignment.centerRight,
                  dropdownColor: color.dark2,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: color.g500,
                  ),
                  style: fonts.ss.copyWith(
                    color: color.white,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  hint: Text(
                    "الفئات",
                    style: fonts.mb.copyWith(
                      color: color.g500,
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          category,
                          style: fonts.ss.copyWith(
                            color: color.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            Productsinputs(
              "نوع السلاح", 
              1, 
              productTypeController,
            ),

            const SizedBox(height: 12),
            Productsinputs(
              "نوع السلاح 2 (اختياري)", 
              1, 
              productType2Controller,
            ),

            
            const SizedBox(height: 12),
            Productsinputs(
              "المودل", 
              1, 
              modelController,
            ),
            
            const SizedBox(height: 12),
            Productsinputs(
              "الوزن", 
              1, 
              weightController,
              keyboardType: TextInputType.number
            ),
            
            const SizedBox(height: 12),
            Productsinputs(
              "الدولة المصنعه", 
              2, 
              manufacturingCountryController,
              minlines: 1
            ),
            
            const SizedBox(height: 12),
            Productsinputs(
              "الشركة المصنعه", 
              2, 
              manufacturingCompanyController,
              minlines: 1
            ),
            
            const SizedBox(height: 12),

            // Usage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: usage,
                      activeColor: color.p500,
                      onChanged: (value) {
                        setState(() {
                          usage = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return color.p500;
                        }
                        return color.p500;
                      }),
                    ),
                    Text("False",style: fonts.ms.copyWith(color: color.g300)),

                    Radio<bool>(
                      value: true,
                      groupValue: usage,
                      activeColor: color.p500,
                      onChanged: (value) {
                        setState(() {
                          usage = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return color.p500;
                        }
                        return color.p500;
                      }),
                    ),
                    Text("True",style: fonts.ms.copyWith(color: color.g300),),
                  ],
                ),

                Text(
                  "الاستخدام",
                  style: fonts.mb.copyWith(color: color.white)
                ),
              ],
            ),

            const SizedBox(height: 12),
            Productsinputs(
              "التقيم", 
              1, 
              ratingController,
              keyboardType: TextInputType.number
            ),
        
            const SizedBox(height: 12),

            // Best Offer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: bestOffer,
                      activeColor: color.p500,
                      onChanged: (value) {
                        setState(() {
                          bestOffer = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return color.p500;
                        }
                        return color.p500;
                      }),
                    ),
                    Text("False",style: fonts.ms.copyWith(color: color.g300)),

                    Radio<bool>(
                      value: true,
                      groupValue: bestOffer,
                      activeColor: color.p500,
                      onChanged: (value) {
                        setState(() {
                          bestOffer = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return color.p500;
                        }
                        return color.p500;
                      }),
                    ),
                    Text("True",style: fonts.ms.copyWith(color: color.g300),),
                  ],
                ),

                Text(
                  "افضل العروض",
                  style: fonts.mb.copyWith(color: color.white)
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            p_button(title: "إضافه المنتج", onPressed: (){},height: 50,),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}