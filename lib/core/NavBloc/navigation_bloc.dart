import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(CurrNavState(0)) {
    on<NavChangeEvent>((event, emit) {
      emit(CurrNavState(event.index));
    });
  }
}
