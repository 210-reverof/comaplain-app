import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:comaplain/screen/login/login_screen.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:comaplain/screen/report_detail/report_detail_screen.dart';

class MapScreen extends StatefulWidget {
  late double targetLat;
  late double targetLng;

  MapScreen(this.targetLat, this.targetLng);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class Post {
  final num id;
  final String title;
  final String explanation;
  final num latitude;
  final num longitude;
  final bool solved;
  final num category;

  Post(
    this.id,
    this.title,
    this.explanation,
    this.latitude,
    this.longitude,
    this.solved,
    this.category,
  );
}

class _MapScreenState extends State<MapScreen> {
  final List _data = [];
  final Set<Marker> markers = new Set();
  String googleApikey = "*****************************";
  final geolocation =
      GoogleMapsGeolocation(apiKey: "*****************************");
  String location = "Search Location";
  GoogleMapController? mapController;
  bool locationPermission = false;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  _fetchData() async {
    final BrokenIcon =
        await getBitmapDescriptorFromAssetBytes("assets/marker_green.png", 90);
    final SafetyIcon =
        await getBitmapDescriptorFromAssetBytes("assets/marker_yellow.png", 90);
    final EtcIcon =
        await getBitmapDescriptorFromAssetBytes("assets/marker_purple.png", 90);

    http.get(Uri.parse('http://34.64.175.9/report/')).then((response) {
      if (response.statusCode == 200) {
        List report_info_res = jsonDecode(utf8.decode(response.bodyBytes));

        for (int i = 0; i < report_info_res.length; i++) {
          var report_info = report_info_res[i];
          Post ReportToAdd = Post(
              report_info['id'] as num,
              report_info['title'] as String,
              report_info['explanation'] as String,
              report_info['latitude'] as num,
              report_info['longitude'] as num,
              report_info['solved'] as bool,
              report_info['category'] as num);

          setState(() {
            _data.add(ReportToAdd);
            var myIcon = _data[i].category == 1
                ? BrokenIcon
                : _data[i].category == 2
                    ? SafetyIcon
                    : EtcIcon;
            markers.add(Marker(
                markerId: MarkerId(_data[i].id.toString()),
                position: LatLng(
                    _data[i].latitude as double, _data[i].longitude as double),
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff05bc71),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Container(
                                          width: 116,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                  child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                strutStyle: const StrutStyle(
                                                    fontSize: 13),
                                                text: TextSpan(
                                                    text: _data[i]
                                                        .title
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                "Roboto",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              )),
                                              Flexible(
                                                  child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                strutStyle: const StrutStyle(
                                                    fontSize: 12.5),
                                                text: TextSpan(
                                                    text: _data[i]
                                                        .explanation
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                          fontSize: 12.5,
                                                          fontFamily: "Roboto",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        )),
                                              )),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              onDoubleTap: () {
                                Navigator.pushNamed(
                                    context, '/ReportDetailScreen',
                                    arguments: ReportDetilArguments(
                                        id: _data[i].id as int,
                                        listUpdate: listUpdate));
                              }),
                        ),
                        Triangle.isosceles(
                          edge: Edge.BOTTOM,
                          child: Container(
                            color: const Color(0xff05bc71),
                            width: 20.0,
                            height: 10.0,
                          ),
                        ),
                      ],
                    ),
                    LatLng(_data[i].latitude as double,
                        _data[i].longitude as double),
                  );
                },
                icon: myIcon));
          });
        }
      } else {
        print('Error!');
      }
    });
  }

  double realCurrLat = 0.0;
  double realCurrLng = 0.0;

  void _currentLocationFloatingBtn() async {
    var res = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    realCurrLat = res.latitude as double;
    realCurrLng = res.longitude as double;

    markers.clear();
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(realCurrLat, realCurrLng), zoom: 12)));
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

  @override
  void initState() {
    _fetchData();
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
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffffcf7),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 100, right: 10),
          child: FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.location_pin),
              backgroundColor: const Color(0xff05bc71),
              onPressed: () {
                _currentLocationFloatingBtn();
              }),
        ),
        body: Stack(children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.targetLat as double, widget.targetLng as double),
                zoom: 12),
            mapType: MapType.normal, //map type
            markers: markers,
            onMapCreated: (GoogleMapController controller) async {
              setState(() {
                _customInfoWindowController.googleMapController = controller;
                mapController = controller;
              });
            },
            //method called when map is created
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 150,
            offset: 50,
          ),
          //search autoconplete input
          Positioned(
              //search input bar
              top: 10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        language: "en",
                        components: [Component(Component.country, 'kr')],
                        //google_map_webservice package
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      setState(() {
                        location = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await const GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);

                      //move map camera to selected place with animation
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 12)));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  ))),
        ]));
  }

  listUpdate() {
    setState(() {});
  }
}
