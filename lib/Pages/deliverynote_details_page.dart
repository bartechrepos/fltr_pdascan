import 'package:fltr_pdascan/Components/cust_drawer.dart';
import 'package:fltr_pdascan/models/deliverynote_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliverynoteDetialsPage extends StatefulWidget {
  DeliverynoteDetialsPage({Key key}) : super(key: key);

  @override
  _DeliverynoteDetialsPageState createState() =>
      _DeliverynoteDetialsPageState();
}

class _DeliverynoteDetialsPageState extends State<DeliverynoteDetialsPage> {
  DeliverynoteType deliverynote;
  @override
  void initState() {
    super.initState();
    setState(() {
      deliverynote = Get.arguments;
    });
    print(deliverynote.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'اذن صرف رقم ' + deliverynote?.serial.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: CustDrawer(),
        body: Container(
          child: Text("Detials "),
        ),
      ),
    );
  }
}
