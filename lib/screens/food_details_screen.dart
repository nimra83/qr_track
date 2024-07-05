// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_saver/models/food_model.dart';
import 'package:food_saver/screens/rating_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FoodDetailsScreen extends StatefulWidget {
  FoodDetailsScreen({super.key, required this.foodModel});

  static String routename = "/foodDetails";

  final FoodModel foodModel;

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final CameraPosition _foodLocation = CameraPosition(
      target: LatLng(widget.foodModel.locationLat as double,
          widget.foodModel.locationLng as double),
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
                  position: LatLng(widget.foodModel.locationLat as double,
                      widget.foodModel.locationLng as double),
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId('radius'),
                  center: LatLng(widget.foodModel.locationLat as double,
                      widget.foodModel.locationLng as double),
                  strokeColor: Colors.red,
                  strokeWidth: 2,
                  fillColor: Colors.red.withOpacity(0.2),
                  radius: 500,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        widget.foodModel.foodName.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.foodModel.picked == false
                          ? InkWell(
                              onTap: () async {
                                double starRating = 0;

                                EasyLoading.show(status: 'Picking Item');
                                CollectionReference collection =
                                    FirebaseFirestore.instance
                                        .collection('foods');
                                String idFieldValue =
                                    widget.foodModel.foodId.toString();
                                print(idFieldValue);
                                QuerySnapshot querySnapshot = await collection
                                    .where('foodId', isEqualTo: idFieldValue)
                                    .get();

                                if (querySnapshot.docs.isNotEmpty) {
                                  await querySnapshot.docs.first.reference
                                      .update({'picked': true});

                                  print(
                                      'Document with field value $idFieldValue Picked successfully');
                                  EasyLoading.dismiss();
                                  Navigator.pushNamed(
                                      context, RatingScreen.routename,
                                      arguments: {
                                        'foodId': widget.foodModel.foodId,
                                      });
                                } else {
                                  print(
                                      'Document with field value $idFieldValue not found');
                                  Navigator.pop(context);
                                }
                                EasyLoading.dismiss();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.check),
                              ),
                            )
                          : Chip(
                              label: Text(
                                'Picked',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                    ],
                  ),
                  widget.foodModel.picked == true
                      ? Row(
                          children: [
                            Text(
                              'Food Rating: ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RatingStars(
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 20,
                              valueLabelColor: const Color(0xff9b9b9b),
                              valueLabelTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0,
                              ),
                              valueLabelRadius: 10,
                              maxValue: 5,
                              starSpacing: 2,
                              value: widget.foodModel.rating == null
                                  ? 0.0
                                  : widget.foodModel.rating!.toDouble(),
                              maxValueVisibility: true,
                              valueLabelVisibility: false,
                              animationDuration: Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 8,
                              ),
                              valueLabelMargin: const EdgeInsets.only(right: 8),
                              starOffColor: const Color(0xffe7e8ea),
                              starColor: Colors.yellow,
                            ),
                          ],
                        )
                      : SizedBox(),
                  widget.foodModel.picked == true
                      ? SizedBox(
                          height: 10,
                        )
                      : SizedBox(),
                  Text(
                    'Food Quantity: ${widget.foodModel.foodQuantity}',
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
                    widget.foodModel.details.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Expiry Date: ${widget.foodModel.expiryDate.toString()}',
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
