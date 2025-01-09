import 'package:equatable/equatable.dart';
import 'package:vehicle/model/bookings.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}
class BookingLoaded extends BookingState {
  final List<Data> unavailableDates;

  BookingLoaded(this.unavailableDates);

  @override
  List<Object?> get props => [unavailableDates];
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
class BookingSuccessState extends BookingState {
  final String message;
  BookingSuccessState({required this.message});
}

class BookingErrorState extends BookingState {
  final String message;
  BookingErrorState({required this.message});
}