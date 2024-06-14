// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_saver/models/food_model.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  static String routename = "/foodsPage";

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  List<FoodModel> foodItemsList = [];

  Future<void> getFoodItems() async {
    foodItemsList = [];
    EasyLoading.show(status: 'Fetching Foods');
    QuerySnapshot<Map<String, dynamic>> foodItemsSnapshot =
        await FirebaseFirestore.instance.collection("foods").get();
    foodItemsSnapshot.docs.map((e) {
      if (selectedValue == 'All') {
        foodItemsList.add(FoodModel.fromJson(e.data()));
      } else if (selectedValue == 'Picked') {
        if ((e.data()['picked'] == true)) {
          foodItemsList.add(FoodModel.fromJson(e.data()));
        }
      } else if (selectedValue == 'Available') {
        if ((e.data()['picked'] == false || e.data()['picked'] == null)) {
          foodItemsList.add(FoodModel.fromJson(e.data()));
        }
      }
    }).toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  String selectedValue = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Foods History'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Filter: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton(
                    value: selectedValue,
                    items: [
                      DropdownMenuItem(
                        child: Text('All'),
                        value: 'All',
                      ),
                      DropdownMenuItem(
                        child: Text('Available'),
                        value: 'Available',
                      ),
                      DropdownMenuItem(
                        child: Text('Picked'),
                        value: 'Picked',
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                        getFoodItems();
                      });
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foodItemsList.length,
                itemBuilder: ((context, index) {
                  FoodModel foodModel = foodItemsList[index];
                  return Card(
                    child: ListTile(
                      title: Text(foodModel.foodName.toString()),
                      subtitle: Text(foodModel.details.toString()),
                      trailing: Container(
                        width: 55,
                        height: 25,
                        decoration: BoxDecoration(
                            color: (foodModel.picked ?? false)
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          (foodModel.picked ?? false) ? 'Picked' : 'Available',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
