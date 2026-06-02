import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

class CompleteInfomation extends StatefulWidget {
  const CompleteInfomation({super.key});

  @override
  State<CompleteInfomation> createState() => _CompleteInfomationState();
}

class _CompleteInfomationState extends State<CompleteInfomation> {

  // google_maps_flutter: ^2.5.3
  // geolocator: ^10.1.0

  // GoogleMapController? mapController;

  // LatLng selectedLocation =
  //     const LatLng(15.3694, 44.1910);

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
  }

  // Future<void> getCurrentLocation() async {

  //   LocationPermission permission =
  //       await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission =
  //         await Geolocator.requestPermission();
  //   }

  //   Position position =
  //       await Geolocator.getCurrentPosition();

  //   setState(() {
  //     selectedLocation = LatLng(
  //       position.latitude,
  //       position.longitude,
  //     );
  //   });

  //   mapController?.animateCamera(
  //     CameraUpdate.newLatLng(selectedLocation),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('اختيار الموقع'),
      ),

      // body: Center(
      //   child: Container(
      //     width: 350,
      //     height: 400,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(15),
      //     ),
      //     child: GoogleMap(
      //       onMapCreated: (controller) {
      //         mapController = controller;
      //       },

      //       initialCameraPosition: CameraPosition(
      //         target: selectedLocation,
      //         zoom: 15,
      //       ),

      //       markers: {
      //         Marker(
      //           markerId: const MarkerId("selected"),
      //           position: selectedLocation,
      //         )
      //       },

      //       onTap: (LatLng position) {
      //         setState(() {
      //           selectedLocation = position;
      //         });
      //       },
      //     ),
      //   ),
      // ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //     print(
      //         "Lat = ${selectedLocation.latitude}");

      //     print(
      //         "Lng = ${selectedLocation.longitude}");

      //   },
      //   child: const Icon(Icons.check),
      // ),
    );
  }
}