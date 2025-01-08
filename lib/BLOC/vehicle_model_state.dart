import 'package:equatable/equatable.dart';
import 'package:vehicle/model/vehicles.dart';

abstract class VehicleModelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleModelInitial extends VehicleModelState {}

class VehicleModelLoading extends VehicleModelState {}

class VehicleModelLoaded extends VehicleModelState {
  final Map<String, Data> vehiclesData;

  VehicleModelLoaded(this.vehiclesData);

  @override
  List<Object?> get props => [vehiclesData];
}

class VehicleModelError extends VehicleModelState {
  final String message;

  VehicleModelError(this.message);

  @override
  List<Object?> get props => [message];
}
