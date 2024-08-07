import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:stripeapp/models/tarjeta_credito.dart';

part 'pagar_event.dart';
part 'pagar_state.dart';

class PagarBloc extends Bloc<PagarEvent, PagarState> {
  PagarBloc() : super(const PagarState()) {
    on<OnSeleccionarTarjeta>(_onSeleccionarTarjeta);
    on<OnDesactivarTarjeta>(_onDesactivarTarjeta);
  }

  void _onSeleccionarTarjeta(
      OnSeleccionarTarjeta event, Emitter<PagarState> emit) {
    emit(state.copyWith(tarjetaActiva: true, tarjeta: event.tarjeta));
  }

  void _onDesactivarTarjeta(
      OnDesactivarTarjeta event, Emitter<PagarState> emit) {
    emit(state.copyWith(tarjetaActiva: false));
  }
}
