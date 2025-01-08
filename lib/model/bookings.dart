class Bookings {
  List<Data>? data;
  String? message;
  int? status;
  Null applicationCode;
  Null stack;

  Bookings(
      {this.data, this.message, this.status, this.applicationCode, this.stack});

  Bookings.fromJson(Map<String, dynamic> json) {
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
  String? vehicleId;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.vehicleId,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicleId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicleId'] = vehicleId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
