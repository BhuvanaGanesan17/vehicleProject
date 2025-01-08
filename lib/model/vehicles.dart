class Vehicle {
  Data? data;
  String? message;
  int? status;
  Null applicationCode;
  Null stack;

  Vehicle(
      {this.data, this.message, this.status, this.applicationCode, this.stack});

  Vehicle.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
    applicationCode = json['applicationCode'];
    stack = json['stack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    data['applicationCode'] = applicationCode;
    data['stack'] = stack;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? vehicleTypeId;
  String? createdAt;
  String? updatedAt;
  VehicleImage? image;

  Data(
      {this.id,
        this.name,
        this.vehicleTypeId,
        this.createdAt,
        this.updatedAt,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vehicleTypeId = json['vehicleTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    image = json['image'] != null ? VehicleImage.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['vehicleTypeId'] = vehicleTypeId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class VehicleImage {
  String? key;
  String? publicURL;

  VehicleImage({this.key, this.publicURL});

  VehicleImage.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    publicURL = json['publicURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['publicURL'] = publicURL;
    return data;
  }
}
