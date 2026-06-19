import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/Inputs/primary_input.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants/api.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class CompleteInfomation extends StatefulWidget {
  const CompleteInfomation({super.key});

  @override
  State<CompleteInfomation> createState() => _CompleteInfomationState();
}

class _CompleteInfomationState extends State<CompleteInfomation> {

  GlobalKey<FormState> formdata = GlobalKey<FormState>();
  TextEditingController First_Name = TextEditingController();
  TextEditingController Last_Name = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Phone_num = TextEditingController();
  TextEditingController Phone_num2 = TextEditingController();
  TextEditingController Location = TextEditingController();
  GoogleMapController? mapController;

  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(15.3694, 44.1910), // صنعاء
    zoom: 13,
  );

  LatLng? selectedLocation;
  Set<Marker> markers = {};
  bool isLoading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String? token = s.getString("token");
    var response = await http.get(
      Uri.parse(Api.profile),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    var data = jsonDecode(response.body);
    if (data["status"] == "success") {
      var user = data["user"];
      var latestLocation = user["latest_location"];
      setState(() {
        First_Name.text = user["first_name"] ?? "";
        Last_Name.text = user["last_name"] ?? "";
        Email.text = user["email"] ?? "";
        Phone_num.text =user["phone_number"] ?? "";
        Phone_num2.text = user["phone_number2"] ?? "";

        if (latestLocation != null){
          Location.text = latestLocation["address"] ?? "";
          double lat = double.tryParse(latestLocation["latitude"].toString()) ?? 15.3694;
          double lng = double.tryParse(latestLocation["longitude"].toString()) ?? 44.1910;
          selectedLocation = LatLng(lat, lng);
          markers = {
            Marker(
              markerId: const MarkerId("selected"),
              position: selectedLocation!,
            ),
          };
        }
      });
    }
  }
  
 double space= 10.5;

  Future<void> _useCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      p_snackbar.show(
        context: context,
        title: "رجاءً فعّل خدمة الموقع أولاً",
        timer: const Duration(seconds: 3),
        background: color.error,
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      p_snackbar.show(
        context: context,
        title: "تم رفض إذن الموقع",
        timer: const Duration(seconds: 3),
        background: color.error,
      );
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      p_snackbar.show(
        context: context,
        title: "تم رفض الإذن نهائيًا، فعّله من الإعدادات",
        timer: const Duration(seconds: 4),
        background: color.error,
      );
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print(position.latitude);
    print(position.longitude);

    final LatLng pos = LatLng(position.latitude, position.longitude);

    setState(() {
      selectedLocation = pos;
      markers = {
        Marker(
          markerId: const MarkerId("selected"),
          position: pos,
        ),
      };
    });

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: pos,
          zoom: 16,
        ),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  return Scaffold(
    resizeToAvoidBottomInset: true,
    backgroundColor: color.dark1,
    appBar: p_appbar(
      title: "اكمل معلوماتك",
      centerTheTitles: true,
      showAction: false,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(8, 8, 8, 16 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: color.f_secondary,
                    backgroundImage: const AssetImage(
                      "assets/images/MainLogo.png",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: color.p500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: color.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Form(
              key: formdata,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: p_input(
                          validator: (value) {
                            if (value!.length > 25) {
                              return "*اجعله اقل من 25 حرف";
                            }
                            if (value.trim().isEmpty) {
                              return null;
                            }
                            if (!RegExp(r'^[a-zA-Z\u0621-\u064A]+$')
                                .hasMatch(value)) {
                              return '* اجعلة حروف فقط';
                            }
                            return null;
                          },
                          controller: Last_Name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\u0621-\u064A]'),
                            ),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            LengthLimitingTextInputFormatter(25),
                          ],
                          label: "الاسم الاخر",
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: p_input(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* الاسم الاول مطلوب";
                            }
                            if (value.length < 2) {
                              return "*اجعله اكثر من 2 حرف";
                            }
                            if (value.length > 25) {
                              return "*اجعله اقل من 25 حرف";
                            }
                            if (!RegExp(r'^[a-zA-Z\u0621-\u064A]+$')
                                .hasMatch(value)) {
                              return '* اجعلة حروف فقط';
                            }
                            return null;
                          },
                          controller: First_Name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\u0621-\u064A]'),
                            ),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            LengthLimitingTextInputFormatter(25),
                          ],
                          label: "الاسم الاول",
                          prefixIcon: const Icon(Icons.person_2_outlined),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: space),

                  p_input(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "* الايميل مطلوب";
                      }
                      if (value.length < 5) {
                        return "* الايميل يجب ان يكون اكثر من 5 حروف";
                      }
                      if (value.length > 40) {
                        return "* الايميل يجب ان يكون اقل من 40 حروف";
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "* صيغة البريد الإلكتروني غير صحيحة";
                      }
                      if (RegExp(r'(:|//|/|\\|\|\||\|)').hasMatch(value)) {
                        return "* الايميل لا يجب ان يحتوي (: , // , / , \\\\ , \\ , || , |)";
                      }
                      return null;
                    },
                    controller: Email,
                    readOnly: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]'),
                      ),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      LengthLimitingTextInputFormatter(40),
                    ],
                    label: "الايميل",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),

                  SizedBox(height: space),

                  p_input(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "*رقم الهاتف مطلوب";
                      }
                      if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                        return "رقم الهاتف يجب ان يحتوي فقط ارقام";
                      }
                      if (!RegExp(r'^\+967(77|73|71|70)\d{7}$')
                          .hasMatch(value)) {
                        return "* ادخل رقم هاتف يمني صحيح (+967)";
                      }
                      if (RegExp(r'(:|//|/|\\|\|\||\|)').hasMatch(value)) {
                        return "رقم الهاتف لا يجب ان يحتوي على (: , // , / , \\\\ , \\ , || , |) ";
                      }
                      return null;
                    },
                    controller: Phone_num,
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      LengthLimitingTextInputFormatter(13),
                    ],
                    label: "رقم الهاتف",
                    icon: 2,
                    suffixIcon: const Icon(Icons.call),
                  ),

                  SizedBox(height: space),

                  p_input(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                        return "رقم الهاتف يجب ان يحتوي فقط ارقام";
                      }
                      if (!RegExp(r'^\+967(77|73|71|70)\d{7}$')
                          .hasMatch(value)) {
                        return "* ادخل رقم هاتف يمني صحيح (+967)";
                      }
                      if (RegExp(r'(:|//|/|\\|\|\||\|)').hasMatch(value)) {
                        return "رقم الهاتف لا يجب ان يحتوي على (: , // , / , \\\\ , \\ , || , |) ";
                      }
                      return null;
                    },
                    controller: Phone_num2,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      LengthLimitingTextInputFormatter(13),
                    ],
                    label: "رقم الهاتف (اختياري)",
                    icon: 2,
                    suffixIcon: const Icon(Icons.call),
                  ),

                  SizedBox(height: space),

                  p_input(
                    controller: Location,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "* العنوان مطلوب";
                      }
                      if (value.trim().length < 3) {
                        return "* اجعل العنوان أكثر من 3 أحرف";
                      }
                      return null;
                    },
                    label: "عنوانك",
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),

                  SizedBox(height: space),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(1),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.g400, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              "تحديد الموقع على الخريطه",
                              style: fonts.mb.copyWith(color: color.white),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),




                        SizedBox(
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                GoogleMap(
                                  initialCameraPosition: initialPosition,
                                  onMapCreated: (GoogleMapController controller) {
                                    mapController = controller;
                                  },
                                  onTap: (LatLng pos) {
                                    setState(() {
                                      selectedLocation = pos;
                                      markers = {
                                        Marker(
                                          markerId: const MarkerId("selected"),
                                          position: pos,
                                        ),
                                      };
                                    });
                                  },
                                  myLocationEnabled: false,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: true,
                                  mapToolbarEnabled: false,
                                  markers: markers,
                                  gestureRecognizers: {
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                ),

                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Material(
                                    color: color.p500,
                                    shape: const CircleBorder(),
                                    elevation: 4,
                                    child: IconButton(
                                      icon: const Icon(Icons.my_location, color: Colors.white),
                                      onPressed: _useCurrentLocation,
                                      tooltip: "تحديد موقعي",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),




                        // SizedBox(
                        //   height: 250,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(10),
                        //     child: GoogleMap(
                        //       initialCameraPosition: initialPosition,
                        //       onMapCreated: (GoogleMapController controller) {
                        //         mapController = controller;
                        //       },
                        //       onTap: (LatLng pos) {
                        //         setState(() {
                        //           selectedLocation = pos;
                        //           markers = {
                        //             Marker(
                        //               markerId: const MarkerId("selected"),
                        //               position: pos,
                        //             ),
                        //           };
                        //         });
                        //       },
                        //       myLocationEnabled: false,
                        //       myLocationButtonEnabled: false,
                        //       zoomControlsEnabled: true,
                        //       mapToolbarEnabled: true,
                        //       markers: markers,
                        //     ),
                        //   ),
                        // ),

                

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: p_button(
            title: "اكمل",
            height: 40,
            isLoading:isLoading ,

            onPressed: () async {
              if (!formdata.currentState!.validate()) return;

              if (selectedLocation == null) {
                p_snackbar.show(
                  context: context,
                  title: "يرجى تحديد موقعك على الخريطة",
                  timer: const Duration(seconds: 3),
                  background: color.error,
                );
                return;
              }

              setState(() {
                isLoading = true;
              });

              try {
                SharedPreferences s = await SharedPreferences.getInstance();
                String? token = s.getString("token");

                var response = await http.post(
                  Uri.parse(Api.completeInformation),
                  headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer $token",
                  },
                  body: jsonEncode({
                    "first_name": First_Name.text.trim(),
                    "last_name": Last_Name.text.trim(),
                    "phone_number2": Phone_num2.text.trim(),
                    "address": Location.text.trim(),
                    "latitude": selectedLocation!.latitude,
                    "longitude": selectedLocation!.longitude,
                  }),
                );

                var data = jsonDecode(response.body);

                if (response.statusCode >= 200 && response.statusCode < 300 && data["status"] == "success") {
                  await s.setInt("complete_information", 1);

                  p_snackbar.show(
                    context: context,
                    title: "تم إكمال المعلومات بنجاح",
                    timer: const Duration(seconds: 3),
                  );

                  Navigator.of(context).pushReplacementNamed("home");
                } else {
                  p_snackbar.show(
                    context: context,
                    title: data["message"] ?? "حدث خطأ أثناء الحفظ",
                    timer: const Duration(seconds: 3),
                    background: color.error,
                  );
                }
              } catch (e) {
                p_snackbar.show(
                  context: context,
                  title: "حدث خطأ: $e",
                  timer: const Duration(seconds: 3),
                  background: color.error,
                );
              }

              setState(() {
                isLoading = false;
              });
            },

          ),
        ),
      ),
    ),
  );
}
  
}


