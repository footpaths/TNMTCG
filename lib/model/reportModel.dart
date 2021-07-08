import 'package:firebase_database/firebase_database.dart';

class reportModel {
  String name;
  String timestamp;
  String phone;
  double lat;
  double long;
  String address;
  String typeprocess;
  String personProcess;
  String individualKey;
  String subAdminArea;
  String sound;
  bool statusProcess;


  dynamic images = new List<String>();
  String imgPerson;
  reportModel(
      this.name,
      this.timestamp,
      this.phone,
      this.lat,
      this.long,
      this.address,
      this.typeprocess,
      this.statusProcess,
      this.individualKey,
      this.subAdminArea,
      this.images,
      this.personProcess,
      this.imgPerson,
      this.sound,
      );

  reportModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        timestamp = snapshot.value["timestamp"],
        phone = snapshot.value["phone"],
        lat = snapshot.value["lat"],
        long = snapshot.value["long"],
        address = snapshot.value["address"],
        typeprocess = snapshot.value["typeprocess"],
        statusProcess = snapshot.value["statusProcess"],
        individualKey = snapshot.key,
        subAdminArea = snapshot.value["subAdminArea"],
        images = snapshot.value["images"],
        personProcess = snapshot.value["personProcess"],
        imgPerson  = snapshot.value["imgPerson"],
        sound  = snapshot.value["sound"];

  toJson() {
    return {
      "name": name,
      "timestamp": timestamp,
      "phone": phone,
      "lat": lat,
      "long": long,
      "address": address,
      "typeprocess": typeprocess,
      "statusProcess": statusProcess,
      "individualKey": individualKey,
      "subAdminArea": subAdminArea,
      "images": images,
      "personProcess": personProcess,
      "imgPerson": imgPerson,
      "sound": sound,
    };
  }
}
