import 'dart:convert';

class UserModel {
  // 필드
  String? firebaseUID;
  String? googleID;
  String? googleProfileImage;
  String? googleName;
  String? appName;
  double? latitude;
  double? longitude;
  DateTime? createdDate;
  DateTime? updatedAt;
  String? address;

  // 생성자
  UserModel(
      {this.firebaseUID,
      this.googleID,
      this.googleProfileImage,
      this.googleName,
      this.appName,
      this.latitude,
      this.longitude,
      this.createdDate,
      this.updatedAt,
      this.address
      });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Map? getJSON = json;
    return UserModel(
        firebaseUID: getJSON["firebase_uid"],
        googleID: getJSON["google_id"],
        googleProfileImage: getJSON["google_profile_image"],
        googleName: getJSON["google_name"],
        appName: getJSON["app_name"],
        latitude: getJSON["latitude"],
        longitude: getJSON["longitude"],
        createdDate: DateTime.parse(getJSON["created_at"]),
        //createdDate: DateTime.parse("2022-02-27T12:24:57.479540Z"),
        //createdDate: getJSON["created_at"],
        updatedAt: DateTime.parse(getJSON["updated_at"]),
        address: getJSON["address"]);
  }

  factory UserModel.fromString(String jsonString) {
    var json = jsonDecode(jsonString);
    return UserModel.fromJson(json);
  }

  Map<String, dynamic> toUserJSON() {
    return {
      "firebase_uid": firebaseUID,
      "google_id": googleID,
      "google_profile_image": googleProfileImage,
      "google_name": googleName,
      "app_name": appName,
      "latitude": latitude,
      "longitude": longitude,
      "created_at": createdDate.toString(),
      "updated_at": updatedAt.toString(),
      "address" : address
    };
  }

  String toUserJSONString() {
    Map<String, dynamic> userJSON = toUserJSON();
    String userJSONString = json.encode(userJSON);

    return userJSONString;
  }
}