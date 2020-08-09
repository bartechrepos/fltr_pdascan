import 'package:flutter/material.dart';

class CustDrawer extends StatelessWidget {
  const CustDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Side Menu'),
          ),
          ListTile(
            title: Text(
              'اذون الصرف',
            ),
          )
        ],
      ),
    );
  }
}
