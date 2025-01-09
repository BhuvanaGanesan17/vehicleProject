import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle/screens/name_screen.dart';

import 'ApiService/api_services.dart';
import 'BLOC/vehicle_booking_bloc.dart';
import 'BLOC/vehicle_model_bloc.dart';
import 'BLOC/vehicle_type_bloc.dart';
import 'BLOC/vehicle_type_event.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VehicleTypeBloc(ApiService())..add(FetchVehicleTypes()),
        ),
        BlocProvider(
          create: (context) => VehicleModelBloc(apiService: ApiService()),
        ), BlocProvider(
          create: (context) => BookingBloc(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Vehicle App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const NameFormScreen(),
      ),
    );
  }
}
