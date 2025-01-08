import 'package:equatable/equatable.dart';
import 'package:vehicle/model/vehicle_type.dart';

abstract class VehicleTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleTypeState {}

class VehicleLoading extends VehicleTypeState {}

class VehicleLoaded extends VehicleTypeState {
  final List<Data> vehicleTypes;
  final Data? selectedVehicle;

  VehicleLoaded(this.vehicleTypes, {this.selectedVehicle});

  @override
  List<Object?> get props => [vehicleTypes, selectedVehicle];
}

class VehicleError extends VehicleTypeState {
  final String message;

  VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}
