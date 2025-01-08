import 'package:equatable/equatable.dart';


abstract class VehicleModelEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchVehicleModels extends VehicleModelEvent {
  final List<String> vehicleIds;

  FetchVehicleModels(this.vehicleIds);

  @override
  List<Object?> get props => [vehicleIds];
}
