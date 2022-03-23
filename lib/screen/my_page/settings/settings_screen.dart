import 'package:comaplain/bloc/user/user_cubit.dart';
import 'package:comaplain/model/user_model.dart';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  //const SettingsScreen({Key? key}) : super(key: key);
  Function setter;

  SettingsScreen(this.setter, {Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double currLatitude;
  late double currLongitude;
  late String currAddress;
  String nameFieldVal = CURRENT_USER.appName.toString();
  bool locationPermission = false;

  @override
  void initState() {
    super.initState();
    getPermission().then((value) {
      if (value) {
        setState(() {
          locationPermission = true;
        });
      } else {
        setState(() {
          locationPermission = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? gCurrentUser = googleSignIn.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xfffffcf7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: backButton(),
      ),
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
            SizedBox(height: 13),
            Text(
              "Settings",
              style: basicTextStyle(24, Color(0xff191919)),
            ),
            SizedBox(height: 30),
            getLable("google account information"),
            SizedBox(height: 12),
            getAcountInfoBox(gCurrentUser!),
            SizedBox(height: 30),
            getLable("name"),
            SizedBox(height: 6),
            Container(
                width: 230,
                height: 50,
                child: TextFormField(
                    initialValue: CURRENT_USER.appName.toString(),
                    onChanged: (val) {
                      setState(() {
                        nameFieldVal = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    border:
                        Border.all(color: const Color(0xffdbdbdb), width: 2),
                    color: const Color(0xffffffff))),
            SizedBox(height: 30),
            getLable("location"),
            SizedBox(height: 6),
            FutureBuilder<Address>(
              future: getCurrentLocation(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  currLatitude = snapshot.data.latitude;
                  currLongitude = snapshot.data.longitude;
                  currAddress = snapshot.data.address;
                  return getAddressBox(snapshot.data, gCurrentUser);
                } else
                  return CircularProgressIndicator();
              },
            ),
          ]),
        ),
      ),
    );
  }

  Row getLable(String str) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 63),
        Text(
          str,
          style: basicTextStyle(17, Color(0xff191919)),
        ),
      ],
    );
  }

  Row getAcountInfoBox(GoogleSignInAccount gCurrentUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 63),
        Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              gCurrentUser.photoUrl.toString(),
              width: 70,
              height: 70,
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gCurrentUser.displayName.toString(),
                style: basicTextStyle(
                  14,
                  Color.fromARGB(255, 85, 85, 85),
                )),
            SizedBox(
              height: 5,
            ),
            Text(gCurrentUser.email.toString(),
                style: basicTextStyle(
                  12,
                  Color.fromARGB(255, 129, 129, 129),
                )),
          ],
        )
      ],
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

  Container getAddressBox(Address position, GoogleSignInAccount gCurrentUser) {
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
                firebaseUID: CURRENT_USER.firebaseUID,
                googleID: CURRENT_USER.googleID,
                googleProfileImage: gCurrentUser.photoUrl,
                googleName: gCurrentUser.displayName,
                appName: nameFieldVal.toString(),
                latitude: position.latitude as double,
                longitude: position.longitude as double,
                createdDate: CURRENT_USER.createdDate,
                updatedAt: DateTime.now(),
                address: position.address);

            BlocProvider.of<UserCubit>(context).addUser(user);

            CURRENT_USER = user;

            widget.setter();
            Navigator.pop(context);
          },
          child: getButtonBox(
              "update settings", Color(0xff05bc71), Color(0xffededed))),
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

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        // 이전 페이지로 이동
        Navigator.pop(context);
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 33, 0, 0),
          child: Image.asset('assets/btn_back.png')),
    );
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
