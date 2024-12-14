import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String? menuId;
  String? sellersUid;
  String? sellersName;
  String? menuTitle;
  String? menuInfo;
  String? menuImage;
  Timestamp? publishedDateTime;
  String? status;

  Menu({
    this.menuId,
    this.sellersUid,
    this.sellersName,
    this.menuTitle,
    this.menuInfo,
    this.menuImage,
    this.publishedDateTime,
    this.status
  });

  Menu.fromJson(Map<String, dynamic> json){
    menuId = json["menuId"];
    sellersUid = json["sellersUid"];
    sellersName = json["sellersName"];
    menuTitle = json["menuTitle"];
    menuImage = json["menuImage"];
    menuInfo = json["menuInfo"];
    publishedDateTime = json["publishedDateTime"];
    status = json["status"];
  }
}