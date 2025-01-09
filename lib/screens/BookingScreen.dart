import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vehicle/ApiService/api_services.dart';
import 'package:vehicle/BLOC/vehicle_booking_bloc.dart';
import 'package:vehicle/BLOC/vehicle_booking_event.dart';
import 'package:vehicle/BLOC/vehicle_booking_state.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
class BookingScreen extends StatefulWidget {
  final String vehicleId;

  const BookingScreen({required this.vehicleId});

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(apiService: ApiService())
        ..add(FetchBookings(widget.vehicleId)),
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
          body: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BookingLoaded) {
                List<DateTime> unavailableDates = [];
                if (state.unavailableDates != null) {
                  for (var booking in state.unavailableDates!) {
                    DateTime startDate = DateTime.parse(booking.startDate!).toLocal();
                    DateTime endDate = DateTime.parse(booking.endDate!).toLocal();

                    while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
                      unavailableDates.add(startDate);
                      startDate = startDate.add(Duration(days: 1));
                    }
                  }
                }

                if (kDebugMode) {
                  print('Unavailable Dates: $unavailableDates');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.range,
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        blackoutDatesDecoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        blackoutDateTextStyle: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      selectableDayPredicate: (DateTime date) {
                        return !unavailableDates.any((unavailableDate) =>
                        unavailableDate.year == date.year &&
                            unavailableDate.month == date.month &&
                            unavailableDate.day == date.day);
                      },
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          setState(() {
                            selectedStartDate = args.value.startDate;
                            selectedEndDate = args.value.endDate;
                          });
                          if (kDebugMode) {
                            print('Selected range: $selectedStartDate to $selectedEndDate');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    // Next Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          bool isUnavailable = false;

                          if (selectedStartDate != null && selectedEndDate != null) {
                            for (var date in unavailableDates) {
                              if ((selectedStartDate!.isBefore(date) || selectedStartDate!.isAtSameMomentAs(date)) &&
                                  (selectedEndDate!.isAfter(date) || selectedEndDate!.isAtSameMomentAs(date))) {
                                isUnavailable = true;
                                break;
                              }
                            }

                            if (isUnavailable) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Selected dates are unavailable.")),
                              );
                            } else {
                              final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Date format
                              String formattedStartDate = formatter.format(selectedStartDate!); // Format start date
                              String formattedEndDate = formatter.format(selectedEndDate!); // Format end date

                              if (kDebugMode) {
                                print('Booking confirmed for: $formattedStartDate to $formattedEndDate');
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Booking confirmed from $formattedStartDate to $formattedEndDate."),
                                ),
                              );
                            }
                          }
                        },

                        child:Container(
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
                            "Confirm Booking",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is BookingError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No data available.'));
              }
            },
          )

      ),
    );
  }

  Widget myBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (selectedStartDate != null && selectedEndDate != null) {
          try {
            if (kDebugMode) {
              print('Booking confirmed for: $selectedStartDate to $selectedEndDate');
            }

            await bookRentalDates(selectedStartDate!, selectedEndDate!);

            context.read<BookingBloc>().add(BookingSuccess(message: "Booking successfully completed!"));
          } catch (e) {
            context.read<BookingBloc>().add(BookingsError(message: "Error booking the rental dates. Please try again."));
          }
        } else {
          context.read<BookingBloc>().add(BookingsError(message: "Please select a valid date range."));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Confirm Booking", // Button text
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> bookRentalDates(DateTime startDate, DateTime endDate) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a network request
    print('Booking confirmed from $startDate to $endDate');
  }
}


