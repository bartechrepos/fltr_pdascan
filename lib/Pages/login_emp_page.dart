import 'package:fltr_pdascan/Components/empserial_input.dart';
import 'package:fltr_pdascan/Pages/deliverynotes_page.dart';
import 'package:fltr_pdascan/models/emp_type.dart';
import 'package:fltr_pdascan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginEmpPage extends StatefulWidget {
  final HoneywellScanner honeywellScanner = HoneywellScanner();

  @override
  _LoginEmpPageState createState() => _LoginEmpPageState();
}

class _LoginEmpPageState extends State<LoginEmpPage>
    with WidgetsBindingObserver
    implements ScannerCallBack {
  bool showSpinner = false;
  String empSerial = "";
  String _error = "";

  @override
  void initState() {
    super.initState();
    scannerSetups();
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
  void onError(Exception error) {
    setState(() {
      _error = error.toString();
    });
  }

  Future<void> _empLogIn(String empSerial) async {
    setState(() {
      showSpinner = true;
    });
    await http
        .get("${Constants.API_URL}/employees?serial=$empSerial")
        .then((response) {
      var respEmps = json.decode(response.body) as List<dynamic>;
      var emp = EmpType.fromJson(respEmps[0]);

      Constants.prefs.setBool(Constants.PDASCR_LOGGED_IN, true);
      Constants.prefs.setString(Constants.PDASCR_LOGGED_USER, emp.toJson());
      Get.off(DeliverynotesPage());
    });
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
  void onDecoded(String result) async {
    await widget.honeywellScanner.stopScanner();
    await _empLogIn(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: _error.isNotEmpty
                      ? Text(
                          _error,
                          style:
                              TextStyle(fontSize: 18, color: Colors.red[400]),
                        )
                      : SizedBox()),
              Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "دخول الموظف",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  )
                ],
              )),
              SizedBox(
                height: 36,
              ),
              Container(
                child: EmpserialInput(
                  title: "كود الموظف",
                  onChanged: (value) {
                    setState(() {
                      empSerial = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              RaisedButton(
                elevation: 5,
                onPressed:
                    empSerial.isNotEmpty ? () => _empLogIn(empSerial) : null,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: Text(
                  "تسجيل",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              RaisedButton.icon(
                  onPressed: () async {
                    await widget.honeywellScanner.startScanner();
                  },
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                  icon: Icon(
                    Icons.scanner,
                    size: 32,
                  ),
                  label: Text(""))
            ],
          ),
        ),
      ),
    );
  }
}
