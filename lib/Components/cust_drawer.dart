import 'package:fltr_pdascan/Pages/deliverynotes_page.dart';
import 'package:fltr_pdascan/Pages/login_emp_page.dart';
import 'package:fltr_pdascan/models/emp_type.dart';
import 'package:fltr_pdascan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustDrawer extends StatefulWidget {
  const CustDrawer({Key key}) : super(key: key);

  @override
  _CustDrawerState createState() => _CustDrawerState();
}

class _CustDrawerState extends State<CustDrawer> {
  EmpType currentEmp;
  @override
  void initState() {
    super.initState();
    if (Constants.prefs.get(Constants.PDASCR_LOGGED_USER) != null) {
      setState(() {
        currentEmp = EmpType.fromString(
            Constants.prefs.get(Constants.PDASCR_LOGGED_USER));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: currentEmp != null
                  ? ListTile(
                      title: Text("مرحباً " + currentEmp?.arname),
                      leading: CircleAvatar(
                        child: Icon(Icons.account_circle),
                      ),
                    )
                  : Text('')),
          ListTile(
            leading: Icon(Icons.move_to_inbox),
            title: Text(
              'اذون الصرف',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Get.to(DeliverynotesPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'تسجيل الخروج',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Constants.prefs.clear();
              Get.off(LoginEmpPage());
            },
          )
        ],
      ),
    );
  }
}
