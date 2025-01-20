import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:emperp_app/features/auth/presentation/usecases/current_user.dart';
import 'package:emperp_app/features/auth/presentation/usecases/user_login.dart';
import 'package:emperp_app/features/auth/presentation/usecases/user_signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  AuthBloc({
    required UserSignup userSignup,
    required UserLogin userLogin,
    required CurrentUser currentUser,
  })  : _userSignup = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
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

    on<AuthLogin>(
      (event, emit) async {
        emit(AuthLoading());
        final res = await _userLogin.call(
          UserLoginParams(
            email: event.email,
            password: event.password,
          ),
        );
        return res.fold(
            (l) => emit(AuthFailure(l.message)), (r) => emit(AuthSuccess(r)));
      },
    );

    on<AuthUserLoggedIn>((event, emit) async {
      final res = await _currentUser();
      res.fold((l) => emit(AuthFailure(l.message)), (r) {
        emit(AuthSuccess(r));
      });
    });
  }
}
