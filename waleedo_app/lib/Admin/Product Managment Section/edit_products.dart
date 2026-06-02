import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../Design System/AppBar/primary_appbar.dart';
import '../../Design System/Buttons/primary_button.dart';
import '../../product_service.dart';
import '../../Design System/SnackBar/primary_snackbar.dart';

class EditProducts extends StatefulWidget {
  final Map<String,dynamic> product;
  const EditProducts({
    super.key,
    required this.product,
  });

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {

  @override
  void initState() {
    super.initState();
    titleController.text = widget.product["title"] ?? "";

    oldPriceController.text = widget.product["oldPrice"].toString();

    newPriceController.text = widget.product["newPrice"].toString();

    descriptionController.text = widget.product["Description"] ?? "";

    caliberController.text = widget.product["caliber"] ?? "";

    capacityController.text = widget.product["capacity"] ?? "";

    selectedCategory = widget.product["category"];

    productTypeController.text = widget.product["ProductType"] ?? "";

    productType2Controller.text = widget.product["ProductType2"] ?? "";

    length = widget.product["length"] == "طويل" ? true :false;

    modelController.text = widget.product["model"] ?? "";

    weightController.text = widget.product["weight"] ?? "";

    manufacturingCountryController.text = widget.product["manufacturing_countrey"] ?? "";

    manufacturingCompanyController.text = widget.product["manufacturing_company"] ?? "";

    ratingController.text = widget.product["rating"].toString();

    usage =
        widget.product["usage"] == 1 ||
        widget.product["usage"] == true;

    bestOffer =
        widget.product["bestOffer"] == 1 ||
        widget.product["bestOffer"] == true;

    selectedType =
        widget.product["type"] ?? "full";

    serverImages =
        List<String>.from(
          widget.product["images"]
        );
  }


  List<String> serverImages =[];
  List<XFile> newImages = [];

  final ImagePicker _picker = ImagePicker();

  // List<XFile> images = [];

  bool addProductLoading =false;

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
  String selectedType = "full";

  bool usage = true;
  bool bestOffer = false;

  bool length = true;

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
        for (var image in pickedImages) {
          bool exists =
              newImages.any(
            (img) =>
                img.path == image.path,
          );
          if (!exists) {
            newImages.add(image);
          }
        }
        newImages.sort(
          (a, b) =>
              a.name.compareTo(b.name),
        );
      });
    }
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
        title: "تعديل المنتجات" ,
        centerTheTitles: true,
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            // الصور
            Text(
              "صور المنتج",
              style: fonts.mb.copyWith(color: color.white),
            ),
           
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImages,
              child: Container(
                width: double.infinity,
                height: serverImages.isEmpty ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(color: color.g500),
                  borderRadius: BorderRadius.circular(12),
                  color: color.dark2
                ),
                child: serverImages.isEmpty && newImages.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: color.g500,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: serverImages.length + newImages.length,

                        itemBuilder: (context, index) {
                          bool isServerImage = index < serverImages.length;
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  child: isServerImage
                                      ? Image.network(
                                          serverImages[index],
                                          width: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(
                                            newImages[
                                              index -
                                              serverImages.length
                                            ].path,
                                          ),
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isServerImage) {
                                          serverImages.removeAt(
                                            index,
                                          );
                                        } else {
                                          newImages.removeAt(
                                            index -
                                            serverImages.length,
                                          );
                                        }
                                      });
                                    },

                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration:
                                          const BoxDecoration(
                                        color: color.error,
                                        shape:
                                            BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: color.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                        


                      ),
              ),
            ),

            const SizedBox(height: 12),

            // العنوان  
            Productsinputs(
              "عنوان المنتج",
              4,
              titleController,
            ),

            const SizedBox(height: 12),
            // نوع القالب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text("اخفاء كامل",style: fonts.ss.copyWith(color: color.g300)),
                        Radio<String>(
                          value: "hideBoth",
                          groupValue: selectedType,
                          activeColor: color.p500,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return color.p500;
                            }
                            return color.p500;
                          }),
                        ),
                        
                        Text("اظهار كامل",style: fonts.ss.copyWith(color: color.g300),),
                        Radio<String>(
                          value: "full",
                          groupValue: selectedType,
                          activeColor: color.p500,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return color.p500;
                            }
                            return color.p500;
                          }),
                        ), 
                      ],
                    ),

                    Row(
                      children: [
                        Text("اخفاء السعر القديم",style: fonts.xsb.copyWith(color: color.g300)),
                        Radio<String>(
                          value: "hideOldPrice",
                          groupValue: selectedType,
                          activeColor: color.p500,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return color.p500;
                            }
                            return color.p500;
                          }),
                        ),

                        Text("اخفاء نسبه الخصم",style: fonts.xsb.copyWith(color: color.g300),),
                        Radio<String>(
                          value: "hideDiscount",
                          groupValue: selectedType,
                          activeColor: color.p500,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                          fillColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return color.p500;
                            }
                            return color.p500;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "النوع",
                  style: fonts.mb.copyWith(color: color.white)
                ),
              ],
            ),

            const SizedBox(height: 12),

            // السعر
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

            // الوصف
            Productsinputs(
              "الوصف", 
              6, 
              descriptionController 
            ),

            const SizedBox(height: 12),
            // العيار
            Productsinputs(
              "العيار", 
              1, 
              caliberController,
            ),

            const SizedBox(height: 12),
            // سعه السلاح
            Productsinputs(
              "سعه السلاح", 
              1, 
              capacityController,
            ),

            const SizedBox(height: 12),

            // الفئات
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
            // نوع السلاح
            Productsinputs(
              "نوع السلاح", 
              1, 
              productTypeController,
            ),

            const SizedBox(height: 12),
            // نوع السلاح2
            Productsinputs(
              "نوع السلاح 2 (اختياري)", 
              1, 
              productType2Controller,
            ),

            const SizedBox(height: 12),
            // الطول
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("قصير",style: fonts.ms.copyWith(color: color.g300)),
                    Radio<bool>(
                      value: false,
                      groupValue: length,
                      activeColor: color.p500,
                      onChanged: (value) {
                        setState(() {
                          length = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return color.p500;
                        }
                        return color.p500;
                      }),
                    ),
                    
                    Text("طويل",style: fonts.ms.copyWith(color: color.g300),),
                    Radio<bool>(
                      value: true,
                      groupValue: length,
                      activeColor: color.p500,
                      onChanged: (value) {
                        setState(() {
                          length = value!;
                        });
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return color.p500;
                        }
                        return color.p500;
                      }),
                    ),
                    
                  ],
                ),

                Text(
                  "الطول",
                  style: fonts.mb.copyWith(color: color.white)
                ),
              ],
            ),
      
            const SizedBox(height: 12),
            // المودل
            Productsinputs(
              "المودل", 
              1, 
              modelController,
            ),
            
            const SizedBox(height: 12),
            //الوزن
            Productsinputs(
              "الوزن", 
              1, 
              weightController,
              keyboardType: TextInputType.number
            ),
            
            const SizedBox(height: 12),
            // الدولة المصنعه
            Productsinputs(
              "الدولة المصنعه", 
              2, 
              manufacturingCountryController,
              minlines: 1
            ),
            
            const SizedBox(height: 12),
            // الشركة المصنعه
            Productsinputs(
              "الشركة المصنعه", 
              2, 
              manufacturingCompanyController,
              minlines: 1
            ),
            
            const SizedBox(height: 12),

            // الاستخدام 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("جديد",style: fonts.ms.copyWith(color: color.g300)),
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
                    
                    Text("مستخدم",style: fonts.ms.copyWith(color: color.g300),),
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
                    
                  ],
                ),

                Text(
                  "الاستخدام",
                  style: fonts.mb.copyWith(color: color.white)
                ),
              ],
            ),

            const SizedBox(height: 12),
            //التقيم
            Productsinputs(
              "التقيم", 
              1, 
              ratingController,
              keyboardType: TextInputType.number
            ),
        
            const SizedBox(height: 12),

            // افضل العروض
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("ايقاف",style: fonts.ms.copyWith(color: color.g300)),
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
                    
                    Text("تفعيل",style: fonts.ms.copyWith(color: color.g300),),
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
                    
                  ],
                ),

                Text(
                  "افضل العروض",
                  style: fonts.mb.copyWith(color: color.white)
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            // زر الارسال
            p_button(
              title: "تعديل المنتج",
              height: 50, 
              isLoading: addProductLoading,
              onPressed: () async {
                setState(() {
                  addProductLoading = true;
                });

                String lengthvalue = length ? "طويل" : "قصير";
                bool success = await ProductService.updateProduct(
                  productId: widget.product["id"],
                  title: titleController.text,
                  type: selectedType,
                  newPrice: newPriceController.text,
                  oldPrice: oldPriceController.text,
                  description: descriptionController.text,
                  caliber: caliberController.text,
                  capacity: capacityController.text,
                  category: selectedCategory ?? "",
                  productType: productTypeController.text,
                  productType2: productType2Controller.text,
                  length: lengthvalue ,
                  model: modelController.text,
                  weight: weightController.text,
                  manufacturingCountry:
                  manufacturingCountryController.text,
                  manufacturingCompany:
                  manufacturingCompanyController.text,
                  rating: ratingController.text,
                  usage: usage,
                  bestOffer: bestOffer,
                  existingImages: serverImages,
                  newImages: newImages,
                );
                if(success){
                  p_snackbar.show(
                    context: context,
                    title: "تم تعديل المنتج بنجاح",
                    timer: Duration(seconds: 4),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pop(context);                  
                }else{

                  p_snackbar.show(
                    context: context,
                    title: "فشل التعديل",
                    timer: Duration(seconds: 4),
                    background: color.error,
                    icon: Icons.cancel,
                  );
                  
                }
                setState(() {
                  addProductLoading =false;
                });
              },
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}