import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle/ApiService/api_services.dart';
import 'package:vehicle/BLOC/vehicle_booking_event.dart';
import 'package:vehicle/BLOC/vehicle_booking_state.dart';


class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiService apiService;

  BookingBloc({required this.apiService}) : super(BookingInitial()) {
    on<FetchBookings>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings = await apiService.bookingData(event.vehicleId);

        final unavailableDates = bookings.data ?? [];

        emit(BookingLoaded(unavailableDates));
      } catch (e) {
        emit(BookingErrorState(message: 'Failed to load bookings: $e'));
      }
    });

    // Handle BookingSuccess event
    on<BookingSuccess>((event, emit) {
      emit(BookingSuccessState(message: event.message));
    });

    // Handle BookingError event
    on<BookingsError>((event, emit) {
      emit(BookingErrorState(message: event.message));
    });
  }
}
