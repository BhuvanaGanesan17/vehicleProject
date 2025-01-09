import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBookings extends BookingEvent {
  final String vehicleId;

  FetchBookings(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}
class BookingSuccess extends BookingEvent {
  final String message;
  BookingSuccess({required this.message});
}

class BookingsError extends BookingEvent {
  final String message;
  BookingsError({required this.message});
}