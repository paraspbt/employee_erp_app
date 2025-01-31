import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final String _currDate;
  GlobalBloc({
    required String currdate,
  })  : _currDate = currdate,
        super(GlobalInitial()) {
    on<UpdateUser>((event, emit) {
      if (event.userModel == null) {
        emit(GlobalInitial());
      } else {
        emit(AppInState(event.userModel!, _currDate));
      }
    });
  }
}
