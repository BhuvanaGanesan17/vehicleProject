import 'package:equatable/equatable.dart';
import 'package:vehicle/model/vehicle_type.dart';

abstract class VehicleTypeEvent extends Equatable {
  List<Object?> get props => [];
}

class FetchVehicleTypes extends VehicleTypeEvent {}

class SelectVehicleInfo extends VehicleTypeEvent {
  final Data selectedVehicle;

  SelectVehicleInfo(this.selectedVehicle);

  @override
  List<Object?> get props => [selectedVehicle];
}
