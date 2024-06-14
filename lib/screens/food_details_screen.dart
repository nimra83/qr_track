// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/food_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoodDetailsScreen extends StatelessWidget {
  FoodDetailsScreen({super.key, required this.foodModel});

  static String routename = "/foodDetails";

  final FoodModel foodModel;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final CameraPosition _foodLocation = CameraPosition(
      target: LatLng(
          foodModel.locationLat as double, foodModel.locationLng as double),
      zoom: 15.0,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Details'),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              initialCameraPosition: _foodLocation,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: const MarkerId('foodLocation'),
                  position: LatLng(foodModel.locationLat as double,
                      foodModel.locationLng as double),
                ),
              },
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff2d2d2d),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        foodModel.foodName.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          EasyLoading.show(status: 'Picking Item');
                          CollectionReference collection =
                              FirebaseFirestore.instance.collection('foods');

                          String idFieldValue = foodModel.foodId.toString();
                          print(idFieldValue);

                          QuerySnapshot querySnapshot = await collection
                              .where('foodId', isEqualTo: idFieldValue)
                              .get();
                          if (querySnapshot.docs.isNotEmpty) {
                            await querySnapshot.docs.first.reference
                                .update({'picked': true});
                            print(
                                'Document with field value $idFieldValue Picked successfully');
                          } else {
                            print(
                                'Document with field value $idFieldValue not found');
                          }
                          EasyLoading.dismiss();
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.check),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Food Quantity: ${foodModel.foodQuantity}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Food Details:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    foodModel.details.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Expiry Date: ${foodModel.expiryDate.toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
