// import 'package:flutter/material.dart';

// class Locations extends StatefulWidget {
//   const Locations({super.key});

//   @override
//   State<Locations> createState() => _LocationsState();
// }

// class _LocationsState extends State<Locations> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waleedo_app/Design%20System/AppBar/primary_appbar.dart';

import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/Inputs/primary_input.dart';
import 'Design System/Buttons/primary_button.dart';
import 'Design System/SnackBar/primary_snackbar.dart';
import 'constants/api.dart';

class Locations extends StatefulWidget {
  final int? locationId;
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;

  const Locations({
    super.key,
    this.locationId,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();

  GoogleMapController? mapController;
  LatLng? selectedLocation;
  Set<Marker> markers = {};
  bool isLoading = false;

  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(15.3694, 44.1910), // صنعاء
    zoom: 13,
  );

  // @override
  // void initState() {
  //   super.initState();

  //   if (widget.initialAddress != null) {
  //     locationController.text = widget.initialAddress!;
  //   }

  //   if (widget.initialLat != null && widget.initialLng != null) {
  //     final pos = LatLng(widget.initialLat!, widget.initialLng!);
  //     selectedLocation = pos;
  //     markers = {
  //       Marker(
  //         markerId: const MarkerId("selected"),
  //         position: pos,
  //       ),
  //     };
  //   }
  // }

  @override
  void initState() {
    super.initState();

    if (widget.initialAddress != null) {
      locationController.text = widget.initialAddress!;
    }

    if (widget.initialLat != null && widget.initialLng != null) {
      final pos = LatLng(widget.initialLat!, widget.initialLng!);
      selectedLocation = pos;
      markers = {
        Marker(
          markerId: const MarkerId("selected"),
          position: pos,
        ),
      };
    }
  }

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

  Future<void> saveLocation() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedLocation == null) {
      p_snackbar.show(
        context: context,
        title: "يرجى تحديد الموقع على الخريطة",
        timer: const Duration(seconds: 3),
        background: color.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final bool isEdit = widget.locationId != null;

      final String url = isEdit
          ? Api.updateLocation(widget.locationId!)
          : Api.addNewLocation;

      final response = isEdit
          ? await http.put(
              Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token",
              },
              body: jsonEncode({
                "address": locationController.text.trim(),
                "latitude": selectedLocation!.latitude,
                "longitude": selectedLocation!.longitude,
              }),
            )
          : await http.post(
              Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token",
              },
              body: jsonEncode({
                "address": locationController.text.trim(),
                "latitude": selectedLocation!.latitude,
                "longitude": selectedLocation!.longitude,
              }),
            );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data["status"] == "success") {
        p_snackbar.show(
          context: context,
          title: isEdit ? "تم تعديل الموقع بنجاح" : "تم حفظ الموقع بنجاح",
          timer: const Duration(seconds: 3),
        );
        Navigator.pop(context, true);
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
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: p_appbar(title: "العناوين",centerTheTitles: true,),
      resizeToAvoidBottomInset: true,
      backgroundColor: color.dark1,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: GoogleMap(
              initialCameraPosition: selectedLocation != null
                  ? CameraPosition(
                      target: selectedLocation!,
                      zoom: 16,
                    )
                  : initialPosition,
              // onMapCreated: (GoogleMapController controller) {
              //   mapController = controller;
              // },


              onMapCreated: (GoogleMapController controller) {
                mapController = controller;

                if (selectedLocation != null) {
                  mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: selectedLocation!,
                        zoom: 16,
                      ),
                    ),
                  );
                }
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
          ),

          Positioned(
            left: 10,
            right: 50,
            bottom: 20 + bottomInset,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.dark2,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: _useCurrentLocation,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "تحديد موقعي",
                              style: fonts.ms.copyWith(
                                color: color.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.my_location,
                              color: color.p,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    p_input(
                      controller: locationController,
                      label: "العنوان",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "* العنوان مطلوب";
                        }
                        if (value.trim().length < 3) {
                          return "* اجعل العنوان أكثر من 3 أحرف";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: p_button(
                        title: widget.locationId == null
                            ? "حفظ الموقع"
                            : "تعديل الموقع",
                        height: 42,
                        isLoading: isLoading,
                        onPressed: saveLocation,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}