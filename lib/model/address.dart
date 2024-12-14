class Address{

  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? lat;
  double? long;

  Address({
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
    this.fullAddress,
    this.lat,
    this.long
});

  Address.fromJson(Map<String, dynamic> json){
    name = json["name"];
    phoneNumber = json["phoneNumber"];
    flatNumber = json["flatNumber"];
    city = json["city"];
    state = json["state"];
    fullAddress = json["fullAddress"];
    lat = json["lat"];
    long = json["long"];
  }
}