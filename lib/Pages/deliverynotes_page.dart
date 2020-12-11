import 'dart:convert';

import 'package:fltr_pdascan/Components/cust_drawer.dart';
import 'package:fltr_pdascan/models/deliverynote_type.dart';
import 'package:fltr_pdascan/models/emp_type.dart';
import 'package:fltr_pdascan/utils/constants.dart';
import 'package:fltr_pdascan/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeliverynotesPage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _DeliverynotesPageState createState() => _DeliverynotesPageState();
}

class _DeliverynotesPageState extends State<DeliverynotesPage> {
  List<DeliverynoteType> deliverynotes = [];

  EmpType currentEmp;

  @override
  void initState() {
    super.initState();
    currentEmp =
        EmpType.fromString(Constants.prefs.get(Constants.PDASCR_LOGGED_USER));
    _getAllDeliveryNotes();
  }

  Future<void> _getAllDeliveryNotes() async {
    deliverynotes = [];
    await http.get("${Constants.API_URL}/delivery-notes").then((response) {
      var data = json.decode(response.body);
      setState(() {
        for (Map i in data) {
          deliverynotes.add(DeliverynoteType.fromJson(i));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 5)).asyncMap((i) =>
          _getAllDeliveryNotes()), // i is null here (check periodic docs)
      builder: (context, snapshot) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: CustDrawer(),
          appBar: AppBar(
            title: Text(
              'اذون الصرف',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _getAllDeliveryNotes,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: deliverynotes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: HexColor(deliverynotes[index]
                                .deliverynoteStatus
                                .hexcode),
                            child: ListTile(
                                title: Text("رقم الاذن " +
                                    deliverynotes[index].serial.toString()),
                                subtitle: Text(deliverynotes[index]
                                    .deliverynoteStatus
                                    .statusArname),
                                trailing: (() {
                                  if (deliverynotes[index]
                                              .deliverynoteStatus
                                              .statusName ==
                                          "Booked" &&
                                      currentEmp?.id ==
                                          deliverynotes[index].bookedBy?.id)
                                    return Icon(Icons.lock_open);
                                  else if (deliverynotes[index]
                                              .deliverynoteStatus
                                              .statusName ==
                                          "Booked" &&
                                      currentEmp?.id !=
                                          deliverynotes[index].bookedBy?.id)
                                    return Icon(Icons.lock);

                                  return Icon(Icons.more_vert);
                                }()),
                                onTap: () {
                                  Get.toNamed('deliverynote_details',
                                      arguments: deliverynotes[index]);
                                }),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
