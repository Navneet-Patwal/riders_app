class Seller{
  String? uid;
  String? email;
  String? name;
  String? image;
  String? phone;
  String? address;
  String? status;
  double? earnings;
  double? latitude;
  double? longitude;


  Seller({
    this.uid,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.address,
    this.status,
    this.earnings,
    this.latitude,
    this.longitude,
});

  Seller.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    name = json["name"];
    email = json["email"];
    image = json["image"];
    phone = json["phone"];
    address = json["address"];
    status = json["status"];
    earnings = json["earnings"];
    latitude = json["latitude"];
    longitude = json["longitude"];
  }
}