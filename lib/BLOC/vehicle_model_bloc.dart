import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle/ApiService/api_services.dart';
import 'package:vehicle/BLOC/vehicle_model_event.dart';
import 'package:vehicle/BLOC/vehicle_model_state.dart';

import '../model/vehicles.dart';


class VehicleModelBloc extends Bloc<VehicleModelEvent, VehicleModelState> {
  final ApiService apiService;

  VehicleModelBloc({required this.apiService}) : super(VehicleModelInitial()) {
    on<FetchVehicleModels>(_onFetchVehicleModels);
  }

  Future<void> _onFetchVehicleModels(
      FetchVehicleModels event, Emitter<VehicleModelState> emit) async {
    emit(VehicleModelLoading());
    Map<String, Data> vehiclesData = {};

    try {
      for (String vehicleId in event.vehicleIds) {
        final vehicle = await apiService.fetchVehicles(vehicleId);
        vehiclesData[vehicleId] = vehicle.data!;
      }
      emit(VehicleModelLoaded(vehiclesData));
    } catch (e) {
      emit(VehicleModelError('Failed to load vehicles: $e'));
    }
  }
}
