// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new
import 'package:comaplain/bloc/user/user_cubit.dart';
import 'package:comaplain/model/user_model.dart';
import 'package:comaplain/repository/user_repository.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:comaplain/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class SignupScreen extends StatefulWidget {
  GoogleSignInAccount currGCurrentUser;

  SignupScreen({required this.currGCurrentUser});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late double currLatitude;
  late double currLongitude;
  late String currAddress;
  TextEditingController nameController = TextEditingController();
  bool locationPermission = false;

  @override
  void initState() {
    super.initState();
    getPermission().then((value) {
      if(value) {
        setState(() {
          locationPermission = true;
        });
      }

      else {
        setState(() {
          locationPermission = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xfffffcf7),
          child: Column(children: [
            SizedBox(height: 73),
            Text(
              "Sign Up",
              style: basicTextStyle(24, Color(0xff191919)),
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 63),
                Text(
                  "Name",
                  style: basicTextStyle(17, Color(0xff191919)),
                ),
              ],
            ),
            SizedBox(height: 6),
            Container(
                width: 230,
                height: 50,
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    border: Border.all(color: const Color(0xffdbdbdb), width: 2),
                    color: const Color(0xffffffff))),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 63),
                Text(
                  "Location",
                  style: basicTextStyle(17, Color(0xff191919)),
                ),
              ],
            ),
            SizedBox(height: 6),
            FutureBuilder<Address>(
              future: getCurrentLocation(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  currLatitude = snapshot.data.latitude;
                  currLongitude = snapshot.data.longitude;
                  currAddress = snapshot.data.address;
                  return getAddressBox(snapshot.data);
                } else
                  return CircularProgressIndicator();
              },
            ),
            SizedBox(height: 10),
            InkWell(
                onTap: () {
                  logoutUser();
                  Navigator.pop(context);
                },
                child:
                    getButtonBox("cancel", Color(0xfffadeac), Color(0xff515151))),
          ]),
        ),
      ),
    );
  }

  Container getButtonBox(String text, Color boxColor, Color textColor) {
    return Container(
        width: 234,
        height: 53,
        child: Center(
          child: Text(text, style: basicTextStyle(16, textColor)),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: boxColor));
  }

  Container getAddressBox(Address position) {
    return Container(
        child: Column(children: [
      locationMemberBox("latitude", position.latitude.toString(), 30),
      SizedBox(height: 6),
      locationMemberBox("longitude", position.longitude.toString(), 30),
      SizedBox(height: 6),
      locationMemberBox("address", position.address.toString(), 60),
      SizedBox(height: 60),
      InkWell(
          onTap: () {
            UserModel user = UserModel(
                firebaseUID: widget.currGCurrentUser.id,
                googleID: widget.currGCurrentUser.email,
                googleProfileImage: widget.currGCurrentUser.photoUrl,
                googleName: widget.currGCurrentUser.displayName,
                appName: nameController.text,
                latitude: position.latitude as double,
                longitude: position.longitude as double,
                createdDate: DateTime.now(),
                updatedAt: DateTime.now(),
                address: position.address);

            BlocProvider.of<UserCubit>(context).addUser(user);

            CURRENT_USER = user;

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => RootScreen()));
          },
          child: getButtonBox("sign up", Color(0xff05bc71), Color(0xffededed))),
    ]));
  }

  Row locationMemberBox(String member, String val, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 63),
        SizedBox(
          width: 60,
          child: Text(
            member,
            style: basicTextStyle(14, Color(0xff999999)),
          ),
        ),
        SizedBox(width: 5),
        Container(
            width: 170,
            height: size,
            child: Center(child: Text(val)),
            decoration: basicTextFromDecoration()),
      ],
    );
  }

  TextStyle basicTextStyle(double size, Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: "Roboto",
        fontStyle: FontStyle.normal,
        fontSize: size);
  }

  BoxDecoration basicTextFromDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        border: Border.all(color: const Color(0xffdbdbdb), width: 2),
        color: const Color(0xffffffff));
  }

  Future<Address> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    String placeName =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    return new Address(
        latitude: position.latitude,
        longitude: position.longitude,
        address: placeName);
  }

  Future<bool> getPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      //print('허락됨');
      return true;
    } else if (status.isDenied) {
      //print('거절됨');
      await Permission.locationWhenInUse.request(); // 허락해달라고 팝업띄우는 코드
      status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        //print('허락됨');
        return true;
      }
    }
    return false;
  }
}

class Address {
  final double? latitude;
  final double? longitude;
  final String? address;

  Address({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
