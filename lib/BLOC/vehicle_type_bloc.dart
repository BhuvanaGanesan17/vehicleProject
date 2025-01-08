import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle/ApiService/api_services.dart';
import 'package:vehicle/BLOC/vehicle_type_event.dart';
import 'package:vehicle/BLOC/vehicle_type_state.dart';
import 'package:vehicle/SQLite/database_helper.dart';

class VehicleTypeBloc extends Bloc<VehicleTypeEvent, VehicleTypeState> {
  final ApiService apiService;

  VehicleTypeBloc(this.apiService) : super(VehicleInitial()) {
    // Fetch vehicle types
    on<FetchVehicleTypes>((event, emit) async {
      emit(VehicleLoading());
      try {
        final vehicleType = await apiService.fetchVehicleTypes();
        emit(VehicleLoaded(vehicleType.data ?? [])); // Default selectedVehicle is null
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<SelectVehicleInfo>((event, emit) async {
      if (state is VehicleLoaded) {
        final currentState = state as VehicleLoaded;

        // Save selected vehicle to SQLite
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.saveData('selected_vehicle', event.selectedVehicle.wheels.toString());

        emit(VehicleLoaded(currentState.vehicleTypes, selectedVehicle: event.selectedVehicle));
      }
    });

  }
}
