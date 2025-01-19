import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:emperp_app/features/auth/presentation/usecases/user_signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;

  AuthBloc({
    required UserSignup userSignup,
  })  : _userSignup = userSignup,
        super(AuthInitial()) {
    on<AuthSignup>(
      (event, emit) async {
        emit(AuthLoading());
        final res = await _userSignup.call(
          UserSignupParams(
            name: event.name,
            email: event.email,
            password: event.password,
          ),
        );
        return res.fold(
            (l) => emit(AuthFailure(l.message)), (r) => emit(AuthSuccess(r)));
      },
    );
  }
}
