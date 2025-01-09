import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:vehicle/ApiService/api_services.dart';
import 'package:vehicle/BLOC/vehicle_model_bloc.dart';

import 'package:vehicle/BLOC/vehicle_model_event.dart';
import 'package:vehicle/BLOC/vehicle_model_state.dart';
import 'package:vehicle/SQLite/database_helper.dart';

import '../model/vehicles.dart';
import 'BookingScreen.dart';

class VehicleModelScreen extends StatefulWidget {
  final List<String> vehicleIds;

  const VehicleModelScreen({super.key, required this.vehicleIds});

  @override
  VehicleModelScreenState createState() => VehicleModelScreenState();
}

class VehicleModelScreenState extends State<VehicleModelScreen> {
  String? selectedVehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleModelBloc(apiService: ApiService())
        ..add(FetchVehicleModels(widget.vehicleIds)),
      child: Scaffold(
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
        body: BlocBuilder<VehicleModelBloc, VehicleModelState>(
          builder: (context, state) {
            if (state is VehicleModelLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VehicleModelLoaded) {
              final vehiclesData = state.vehiclesData;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Please select specific model"),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vehiclesData.length,
                    itemBuilder: (context, index) {
                      String vehicleId = widget.vehicleIds[index];
                      Data vehicle = vehiclesData[vehicleId]!;

                      return Card(
                        elevation: 4.0, // Adds elevation for a shadow effect
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Rounded corners for the card
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Padding inside the card
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio<String>(
                                value: vehicleId,
                                groupValue: selectedVehicleId,
                                onChanged: (value) {
                                  setState(() {
                                    selectedVehicleId = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                  width:
                                      16.0), // Space between the image and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vehicle.name ?? 'Unnamed Vehicle',
                                      style: const TextStyle(
                                        fontSize:
                                            15.0, // Slightly larger font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            4.0), // Space between name and additional info
                                  ],
                                ),
                              ),
                              if (vehicle.image?.publicURL != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Rounded corners for the image
                                  child: Image.network(
                                    vehicle.image!.publicURL!,
                                    width:
                                        100, // Increased width for larger image
                                    height:
                                        100, // Increased height for larger image
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the space without distortion
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: myBtn(context, vehiclesData, selectedVehicleId),
                  ),
                ],
              );
            } else if (state is VehicleModelError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }
  Widget myBtn(BuildContext context, Map<String, Data> vehiclesData, String? selectedVehicleId) {
    return GestureDetector(
      onTap: () async {
        if (selectedVehicleId != null) {
          // Save selected vehicle details
          final selectedVehicle = vehiclesData[selectedVehicleId]!;
          final dbHelper = DatabaseHelper.instance;

          await dbHelper.saveData(
            'selected_vehicle_id',
            selectedVehicleId!,
          );
          await dbHelper.saveData(
            'selected_vehicle_name',
            selectedVehicle.name ?? 'Unnamed Vehicle',
          );
          await dbHelper.saveData(
            'selected_vehicle_image',
            selectedVehicle.image?.publicURL ?? 'Unnamed image',
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(vehicleId: selectedVehicleId),
            ),
          );
          // Perform next action (e.g., navigation)
        } else {
          // Show validation message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a vehicle model.')),
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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          "Next".toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}
