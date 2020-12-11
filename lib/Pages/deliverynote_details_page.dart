import 'package:badges/badges.dart';
import 'package:fltr_pdascan/models/deliverynote_detail_type.dart';
import 'package:fltr_pdascan/models/deliverynote_type.dart';
import 'package:fltr_pdascan/models/emp_type.dart';
import 'package:fltr_pdascan/utils/constants.dart';
import 'package:fltr_pdascan/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:async";

class DeliverynoteDetialsPage extends StatefulWidget {
  final HoneywellScanner honeywellScanner = HoneywellScanner();
  @override
  _DeliverynoteDetialsPageState createState() =>
      _DeliverynoteDetialsPageState();
}

class _DeliverynoteDetialsPageState extends State<DeliverynoteDetialsPage>
    with WidgetsBindingObserver
    implements ScannerCallBack {
  DeliverynoteType deliverynote;
  List<DeliverynoteDetailType> details = [];
  String _error = "";
  EmpType currentEmp;
  bool scanStarted = false;
  bool fulfilled = false;

  @override
  void initState() {
    super.initState();
    scannerSetups();
    setState(() {
      deliverynote = Get.arguments;
      currentEmp =
          EmpType.fromString(Constants.prefs.get(Constants.PDASCR_LOGGED_USER));
    });
    _getDeliverynoteDetails();
  }

  void scannerSetups() async {
    widget.honeywellScanner.scannerCallBack = this;
    await widget.honeywellScanner.setProperties(CodeFormatUtils.get()
        .getFormatsAsProperties(
            [CodeFormat.CODE_128, CodeFormat.QR_CODE, CodeFormat.DATA_MATRIX]));
    try {
      await widget.honeywellScanner.stopScanner();
    } catch (e) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state = $state');
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await widget.honeywellScanner.stopScanner();
    } else if (state == AppLifecycleState.resumed) {
      await widget.honeywellScanner.startScanner();
    }
  }

  @override
  void onDecoded(String result) {
    addScanned(result);
  }

  void stopScan() async {
    await widget.honeywellScanner.stopScanner();
    setState(() {
      scanStarted = false;
    });
  }

  void moveDeliveryNote() async {
    var deliverynoteStatus = "";

    if (deliverynote.deliverynoteStatus.statusName == "Booked")
      deliverynoteStatus = "3";
    else if (deliverynote.deliverynoteStatus.statusName == "Revision")
      deliverynoteStatus = "4";
    var body = {"deliverynote_status": deliverynoteStatus};
    if (deliverynoteStatus == "4")
      body["reviewed_by"] = currentEmp.id.toString();

    if (deliverynoteStatus.isNotEmpty) {
      await http.put("${Constants.API_URL}/delivery-notes/${deliverynote.id}",
          body: body);
      Get.snackbar(
        "",
        "اتمام اذن الصرف بنجاح",
        snackPosition: SnackPosition.BOTTOM,
      );
      await Future.delayed(new Duration(seconds: 2));
      Get.offNamed("/deliverynotes");
    }
  }

  void addScanned(String code) {
    var index =
        details.indexWhere((element) => element.product.barcode == code);

    if (details[index].scanned == null ||
        details[index].scanned < details[index].quantity) {
      details[index].scanned =
          details[index].scanned != null ? details[index].scanned + 1 : 1;
    } else {
      Get.snackbar(
          "خطأ في اضافة الكود", "لا يمكن اضافة عدد باكثر من الكمية المطلوبة",
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red[500]);
    }

    /*
    details.forEach((element) {
      if(element.scanned >= element.quantity  ) fulfilled = true;
      else fulfilled = false;
    })
    */
    var minIndex = details
        .indexWhere((elm) => elm.scanned == null || elm.scanned < elm.quantity);
    if (minIndex == -1) {
      fulfilled = true;
      if (scanStarted) stopScan();
    }
    setState(() {});
  }

  @override
  void onError(Exception error) {
    setState(() {
      _error = error.toString();
    });
  }

  Future<void> _getDeliverynoteDetails() async {
    details = [];
    await http
        .get(
            "${Constants.API_URL}/deliverynote-details?delivery_note=${deliverynote.id}")
        .then((response) {
      var data = json.decode(response.body);
      setState(() {
        for (Map i in data) {
          details.add(DeliverynoteDetailType.fromJson(i));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'اذن صرف رقم ' + deliverynote?.serial.toString(),
            style: TextStyle(color: Colors.teal[800]),
          ),
          backgroundColor: HexColor(deliverynote?.deliverynoteStatus?.hexcode),
        ),
        //drawer: CustDrawer(),
        body: RefreshIndicator(
          onRefresh: _getDeliverynoteDetails,
          child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                      child: _error.isNotEmpty
                          ? Text(
                              _error,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.red[400]),
                            )
                          : SizedBox()),
                  Expanded(
                    child: ListView.builder(
                        itemCount: details.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Badge(
                              //animationType: BadgeAnimationType.scale,
                              badgeContent: Text(
                                details[index].scanned != null
                                    ? details[index].scanned.toString()
                                    : "0",
                                style: TextStyle(
                                    color: Colors.teal[600], fontSize: 20),
                              ),
                              padding: EdgeInsets.all(8),
                              badgeColor: Colors.teal[200],
                              position: BadgePosition.topLeft(),
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          details[index].product?.coverImg),
                                    ),
                                    title: Text(details[index].product?.name),
                                    trailing: InkWell(
                                      onTap: () => addScanned(
                                          details[index].product?.barcode),
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          details[index].quantity.toString(),
                                          style: TextStyle(
                                              color: Colors.teal[600],
                                              fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  if (deliverynote.deliverynoteStatus.statusName == "Created")
                    RaisedButton(
                      elevation: 5,
                      onPressed: () async {
                        await http.put(
                            "${Constants.API_URL}/delivery-notes/${deliverynote.id}",
                            body: {
                              "deliverynote_status": "2",
                              "booked_by": currentEmp.id.toString()
                            });
                        Get.snackbar(
                          "",
                          "تم حجز اذن الصرف بنجاح",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        await Future.delayed(new Duration(seconds: 2));
                        Get.offNamed("/deliverynotes");
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      child: Text(
                        "حجز اذن الصرف ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  if (deliverynote.deliverynoteStatus.statusName ==
                          "Revision" &&
                      currentEmp.empType.step > 1 &&
                      !scanStarted &&
                      !fulfilled)
                    RaisedButton.icon(
                      icon: Icon(Icons.scanner),
                      elevation: 5,
                      onPressed: () async {
                        await widget.honeywellScanner.startScanner();
                        setState(() {
                          scanStarted = true;
                        });
                      },
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      label: Text(
                        "بدء المراجعة ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  if (deliverynote.deliverynoteStatus.statusName == "Booked" &&
                      !scanStarted &&
                      !fulfilled)
                    RaisedButton.icon(
                      icon: Icon(Icons.scanner),
                      onPressed: currentEmp.id == deliverynote.bookedBy?.id
                          ? () async {
                              await widget.honeywellScanner.startScanner();
                              setState(() {
                                scanStarted = true;
                              });
                            }
                          : null,
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      label: Text(
                        "بدء المسح",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  if (scanStarted)
                    RaisedButton.icon(
                      icon: Icon(Icons.stop),
                      elevation: 5,
                      onPressed: stopScan,
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      label: Text(
                        "انهاء المسح ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  if (fulfilled)
                    RaisedButton(
                      elevation: 5,
                      onPressed: moveDeliveryNote,
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      child: Text(
                        "اتمام اذن الصرف ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  SizedBox(
                    height: 24,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
