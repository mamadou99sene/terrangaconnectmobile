import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:terangaconnect/core/app_export.dart';
import 'package:terangaconnect/models/Utilisateur.dart';

class Donespecescreen extends StatelessWidget {
  late String declarationId;
  late Utilisateur utilisateur;
  Donespecescreen({required this.declarationId, required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Don Espece'),
        ),
        body: // Figma Flutter Generator Iphone1314231Widget - FRAME
            Container(
                width: 390,
                height: 844,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 56,
                      left: 91,
                      child: Text('Meci de choisir un operateur',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge)),
                  Positioned(
                      top: 201,
                      left: 19,
                      child: Container(
                          width: 169,
                          height: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              width: 1,
                            ),
                          ))),
                  Positioned(
                      top: 352,
                      left: 19,
                      child: Container(
                          width: 169,
                          height: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              width: 1,
                            ),
                          ))),
                  Positioned(
                      top: 201,
                      left: 201,
                      child: Container(
                          width: 169,
                          height: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              width: 1,
                            ),
                          ))),
                  Positioned(
                      top: 352,
                      left: 201,
                      child: Container(
                          width: 169,
                          height: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              width: 1,
                            ),
                          ))),
                  Positioned(
                      top: 248,
                      left: 40,
                      child: Container(
                          width: 129,
                          height: 42,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Orange_moneylogo1.png'),
                                fit: BoxFit.fitWidth),
                          ))),
                  Positioned(
                      top: 249,
                      left: 240,
                      child: Container(
                          width: 91,
                          height: 39.96086883544922,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 91,
                                    height: 39.96086883544922,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Navlogo1.png'),
                                          fit: BoxFit.fitWidth),
                                    ))),
                          ]))),
                  Positioned(
                      top: 383,
                      left: 249,
                      child: Container(
                          width: 74,
                          height: 73,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/Paypal_2014_logo1.png'),
                                fit: BoxFit.fitWidth),
                          ))),
                  Positioned(
                      top: 46,
                      left: 19,
                      child: Container(
                          width: 49,
                          height: 49,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(247, 247, 247, 1),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(49, 49)),
                          ))),
                  Positioned(
                      top: 402,
                      left: 57,
                      child: Container(
                          width: 94,
                          height: 35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/2722720211_cartovisaemasterpnglogovisae1.png'),
                                fit: BoxFit.fitWidth),
                          ))),
                  Positioned(
                      top: 64,
                      left: 35,
                      child: Container(
                          width: 20.000036239624023,
                          height: 13,
                          child: Stack(children: <Widget>[
                            Positioned(
                              top: 0,
                              left: 0,
                              child: SvgPicture.asset(
                                  'assets/images/vector.svg',
                                  semanticsLabel: 'vector'),
                            ),
                          ]))),
                ])));
  }
}
