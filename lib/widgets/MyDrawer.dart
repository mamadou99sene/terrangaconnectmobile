import 'package:flutter/material.dart';
import 'package:terangaconnect/core/utils/image_constant.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(children: [
        DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 52, 1, 1),
              Colors.red,
              Colors.white
            ])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ImageConstant.imgUser),
                  backgroundColor: Colors.red[300],
                  radius: 50,
                ),
                Text(
                  "Prenom nom",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                )
              ],
            )),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            //routes
          },
          leading: Icon(
            Icons.home,
            color: Colors.red,
          ),
          trailing: Icon(
            Icons.arrow_right,
            color: Colors.red,
          ),
          title: Text(
            "Home",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
          ),
        ),
        const Divider(
          height: 5,
          color: Colors.red,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            //routes
          },
          leading: Icon(
            Icons.meeting_room,
            color: Colors.red,
          ),
          trailing: Icon(
            Icons.arrow_right,
            color: Colors.red,
          ),
          title: Text(
            "Rendez vous",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
          ),
        ),
        const Divider(
          height: 5,
          color: Colors.red,
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            //routes
          },
          leading: Icon(
            Icons.local_hospital,
            color: Colors.red,
          ),
          trailing: Icon(
            Icons.arrow_right,
            color: Colors.red,
          ),
          title: Text(
            "structure de santé",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
          ),
        )
      ]),
    );
  }
}
