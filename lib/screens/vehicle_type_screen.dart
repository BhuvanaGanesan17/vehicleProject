import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle/BLOC/vehicle_type_bloc.dart';
import 'package:vehicle/BLOC/vehicle_type_event.dart';
import 'package:vehicle/BLOC/vehicle_type_state.dart';
import 'package:vehicle/SQLite/database_helper.dart';

import 'package:vehicle/model/vehicle_type.dart';


import 'ModelScreen.dart';

class VehicleTypeScreen extends StatelessWidget {
  final int selectedWheels;

  const VehicleTypeScreen({super.key, required this.selectedWheels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Text(
          "Vehicle App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      body: BlocBuilder<VehicleTypeBloc, VehicleTypeState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.all(10.0),
                  child:    Text("Please select vehicle type"),),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.vehicleTypes.length,
                  itemBuilder: (context, index) {
                    final vehicle = state.vehicleTypes[index];
                    final isSelected = state.selectedVehicle == vehicle; // Selected state logic
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple.shade400 : Colors.black12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<Data>(
                        value: vehicle,
                        groupValue: state.selectedVehicle,
                        title: Text(" ${vehicle.type} "),
                        onChanged: (selected) {
                          context.read<VehicleTypeBloc>().add(SelectVehicleInfo(selected!));
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: myBtn(context, state.selectedVehicle),
                ),
              ],
            );
          } else if (state is VehicleError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No data available"));
        },
      ),

    );
  }
  Widget myBtn(BuildContext context, Data? selectedVehicle) {
    return GestureDetector(
      onTap: () async {
        final dbHelper = DatabaseHelper.instance;

        if (selectedVehicle != null) {
          if (selectedVehicle.wheels != selectedWheels) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('The selected vehicle type does not correspond to the selected wheels.')),
            );
          } else {
            await dbHelper.saveData('selected_vehicle', selectedVehicle.type.toString());
            await dbHelper.saveData('selected_vehicle_id', selectedVehicle.vehicles![0].id.toString());


            List<String> vehicleIds = [];

            for (var vehicle in selectedVehicle.vehicles!) {
              if (vehicle.id != null) {
                vehicleIds.add(vehicle.id!);
              }
            }


            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleModelScreen(
                  vehicleIds: vehicleIds, // Pass the list of IDs
                ),
              ),
            );



          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a vehicle type before proceeding.')),
          );
        }
      },
      child: Container(
        width: 200,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade400,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          "Next".toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
      ),
    );
  }
}

