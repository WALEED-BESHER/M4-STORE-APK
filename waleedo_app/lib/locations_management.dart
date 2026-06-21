import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';
import 'Design System/Buttons/primary_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/api.dart';
import 'locations.dart';
import 'Design System/SnackBar/primary_snackbar.dart';


// class LocationItem {
//   final int id;
//   final String address;
//   final bool active;

//   LocationItem({
//     required this.id,
//     required this.address,
//     required this.active,
//   });

//   factory LocationItem.fromJson(Map<String, dynamic> json) {
//     return LocationItem(
//       id: json['id'],
//       address: json['address'] ?? '',
//       active: json['active'] == true || json['active'] == 1,
//     );
//   }
// }

class LocationItem {
  final int id;
  final String address;
  final bool active;
  final double latitude;
  final double longitude;

  LocationItem({
    required this.id,
    required this.address,
    required this.active,
    required this.latitude,
    required this.longitude,
  });

  factory LocationItem.fromJson(Map<String, dynamic> json) {
    return LocationItem(
      id: json['id'],
      address: json['address'] ?? '',
      active: json['active'] == true || json['active'] == 1,
      latitude: double.tryParse(json['latitude'].toString()) ?? 15.3694,
      longitude: double.tryParse(json['longitude'].toString()) ?? 44.1910,
    );
  }
}

class LocationsManagement extends StatefulWidget {
  const LocationsManagement({super.key});

  @override
  State<LocationsManagement> createState() => _LocationsManagementState();
}

class _LocationsManagementState extends State<LocationsManagement> {

  List<LocationItem> locations = [];
  bool loading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  Future<void> getLocations() async {
    setState(() {
      loading = true;
    });

    final s = await SharedPreferences.getInstance();
    token = s.getString("token");

    final response = await http.get(
      Uri.parse(Api.getUserLocations),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data["locations"] as List;

      setState(() {
        locations = list.map((e) => LocationItem.fromJson(e)).toList();
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> makeActive(int id) async {
    final response = await http.post(
      Uri.parse(Api.setActiveLocation(id)),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      await getLocations();
    }
  }

  Future<void> deleteLocation(int id) async {
    final response = await http.delete(
      Uri.parse(Api.deleteLocation(id)),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await getLocations();
    }else{
      p_snackbar.show(
        context: context, 
        title: data['message'] ?? 'حدث خطأ أثناء الحذف',
        timer: Duration(seconds: 5),
        background: color.error,
        icon: Icons.cancel,
      );
    }
  }


  Future<void> deleteingLocation(int id, String massage) async {
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
          height: 40,
          child: Center(
            child: Text(
              'هل أنت متأكد من حذف هذا العنوان؟'
              '\n ${massage}',
              style: fonts.ss.copyWith(
                color: color.white,
              ),
              textAlign: TextAlign.end,
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
              deleteLocation(id);
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "اداره العناوين",
        centerTheTitles: true,
      ),


      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  children: [
                    ...locations.map((location) {
                      bool active = location.active;

                      return InkWell(
                        onTap: active ? null : () => makeActive(location.id),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: active ? color.p : color.g500,
                              width: active ? 2 : 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      location.address,
                                      textAlign: TextAlign.right,
                                      style: fonts.sm.copyWith(
                                        color: color.g200,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? color.p
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: color.g200,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      // onPressed: () async {
                                      //   final result = await Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (_) => Locations(
                                      //         locationId: location.id,
                                      //         initialAddress: location.address,
                                      //       ),
                                      //     ),
                                      //   );

                                      //   if (result == true) {
                                      //     getLocations();
                                      //   }
                                      // },

                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Locations(
                                              locationId: location.id,
                                              initialAddress: location.address,
                                              initialLat: location.latitude,
                                              initialLng: location.longitude,
                                            ),
                                          ),
                                        );

                                        if (result == true) {
                                          getLocations();
                                        }
                                      },


                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: color.g500),
                                        backgroundColor: color.b_hovergrey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        "تعديل",
                                        style: fonts.ms.copyWith(
                                          color: color.g300,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: OutlinedButton.icon(
                                        onPressed: locations.length <= 1 
                                        ? (){
                                          p_snackbar.show(
                                            context: context, 
                                            title: 'لا يمكنك حذف هذا العنوان لأنك يجب أن تحتفظ بعنوان واحد على الأقل',
                                            timer: Duration(seconds: 5),
                                            background: color.error,
                                            icon: Icons.cancel,
                                          );
                                        } 
                                        :() {
                                          deleteingLocation(location.id,location.address);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: color.p,
                                        ),
                                        label: Text(
                                          "حذف",
                                          style: fonts.ms.copyWith(
                                            color: color.p,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: color.p),
                                          backgroundColor: color.b_defultred,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: p_button(
            title: "إضافة",
            height: 40,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Locations(),
                ),
              );
              if (result == true) {
                getLocations();
              }
            },
          ),
        ),
      ),

    );
  }
}