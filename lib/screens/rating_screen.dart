// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_saver/screens/dashboard/dashboard.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.foodId});

  static String routename = "/Mainpage";

  final String foodId;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double ratingValue = 0;

  Future<void> updateFoodRating(String foodId, double rating) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('foods');
    try {
      QuerySnapshot querySnapshot =
          await collection.where('foodId', isEqualTo: foodId).get();
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({'rating': rating});
        print('Rating updated successfully');
      } else {
        print('Document with field value $foodId not found');
      }
    } catch (e) {
      print('Failed to update rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Food Rating'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Rate the Food',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RatingStars(
              value: ratingValue,
              onValueChanged: (v) {
                setState(() {
                  ratingValue = v;
                });
              },
              starBuilder: (index, color) => Icon(
                Icons.star,
                size: 50,
                color: color,
              ),
              starCount: 5,
              starSize: 50,
              valueLabelColor: const Color(0xff9b9b9b),
              valueLabelRadius: 10,
              maxValue: 5,
              starSpacing: 2,
              maxValueVisibility: true,
              valueLabelVisibility: false,
              animationDuration: Duration(milliseconds: 1000),
              starOffColor: const Color(0xffe7e8ea),
              starColor: Colors.yellow,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                updateFoodRating(widget.foodId, ratingValue).then((value) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(Dashboard.routename));
                });
              },
              child: Text(
                'Rate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
