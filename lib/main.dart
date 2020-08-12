import 'package:fltr_pdascan/Pages/deliverynote_details_page.dart';
import 'package:fltr_pdascan/Pages/deliverynotes_page.dart';
import 'package:fltr_pdascan/Pages/home_page.dart';
import 'package:fltr_pdascan/Pages/login_emp_page.dart';
import 'package:fltr_pdascan/Pages/login_page.dart';
import 'package:fltr_pdascan/Pages/scanner_page.dart';
import 'package:fltr_pdascan/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Constants.prefs = await SharedPreferences.getInstance();
  } catch (e) {}
  print(Constants.prefs);

  //runApp(MyApp());
  runApp(GetMaterialApp(
    theme: ThemeData(primaryColor: Colors.teal[200]),
    initialRoute: Constants.prefs.getBool("PDASCR_LOGGED_IN") == true
        ? 'deliverynotes'
        : 'login_emp',

    /*
    initialRoute: Constants.prefs.getBool("PDASCR_LOGGED_IN") == true
        ? 'home'
        : 'login',
    */
    //initialRoute: 'login',
    getPages: [
      GetPage(name: '/home', page: () => HomePage()),
      GetPage(name: '/login', page: () => LoginPage()),
      GetPage(name: '/login_emp', page: () => LoginEmpPage()),
      GetPage(name: '/scanner', page: () => ScannerPage()),
      GetPage(name: '/deliverynotes', page: () => DeliverynotesPage()),
      GetPage(
          name: '/deliverynote_details', page: () => DeliverynoteDetialsPage()),
    ],
  ));
}
