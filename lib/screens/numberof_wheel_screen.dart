import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle/BLOC/vehicle_type_bloc.dart';
import 'package:vehicle/BLOC/vehicle_type_event.dart';
import 'package:vehicle/BLOC/vehicle_type_state.dart';
import 'package:vehicle/SQLite/database_helper.dart';

import 'package:vehicle/model/vehicle_type.dart';
import 'package:vehicle/screens/vehicle_type_screen.dart';

class NumberOfWheelScreen extends StatelessWidget {
  const NumberOfWheelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
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
             child:    Text("Please select vehicle wheel"),),


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
                          color: isSelected ? Colors.deepPurple.shade300 : Colors.black12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<Data>(
                        value: vehicle,
                        groupValue: state.selectedVehicle, // No pre-selection if groupValue is null
                        title: Text(" ${vehicle.wheels} wheels"),
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
                  child: myBtn(context),
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
  Widget myBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final state = context.read<VehicleTypeBloc>().state;
        final dbHelper = DatabaseHelper.instance;

        if (state is VehicleLoaded && state.selectedVehicle != null) {
          // Fetch saved data
          final savedData = await dbHelper.fetchAllData();
          final savedWheels = savedData['selected_vehicle'];

          // Check if the selected data is already saved
          if (savedWheels == state.selectedVehicle!.wheels.toString()) {
            // Data already saved, proceed to the next screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleTypeScreen(
                    selectedWheels: int.parse(savedWheels.toString())),
              ),
            );
          } else {
            // Save new data
            await dbHelper.saveData(
              'selected_vehicle',
              state.selectedVehicle!.wheels.toString(),
            );

            // Proceed to the next screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleTypeScreen(
                    selectedWheels: int.parse(state.selectedVehicle!.wheels.toString())),
// Pass selected wheels

              ),
            );
          }
        } else {
          // Show validation message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a vehicle wheels before proceeding.')),
          );
        }
      },
      child: Container(
        width: 200,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade300,
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
