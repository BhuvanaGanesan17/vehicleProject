class VehicleType {
  List<Data>? data;
  String? message;
  int? status;
  Null applicationCode;
  Null stack;

  VehicleType(
      {this.data, this.message, this.status, this.applicationCode, this.stack});

  VehicleType.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    applicationCode = json['applicationCode'];
    stack = json['stack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
  int? wheels;
  String? type;
  String? createdAt;
  String? updatedAt;
  List<Vehicles>? vehicles;

  Data(
      {this.id,
        this.name,
        this.wheels,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.vehicles});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    wheels = json['wheels'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['wheels'] = wheels;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  String? id;
  String? name;
  String? vehicleTypeId;
  String? createdAt;
  String? updatedAt;

  Vehicles(
      {this.id, this.name, this.vehicleTypeId, this.createdAt, this.updatedAt});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vehicleTypeId = json['vehicleTypeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['vehicleTypeId'] = vehicleTypeId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
