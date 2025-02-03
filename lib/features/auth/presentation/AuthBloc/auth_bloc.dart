import 'package:emperp_app/core/GlobalBloc/global_bloc.dart';
import 'package:emperp_app/features/auth/data/models/user_model.dart';
import 'package:emperp_app/features/auth/presentation/usecases/current_user.dart';
import 'package:emperp_app/features/auth/presentation/usecases/log_out.dart';
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
  final LogOut _logOut;
  final GlobalBloc _globalBloc;
  AuthBloc({
    required UserSignup userSignup,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required GlobalBloc globalBloc,
    required LogOut logOut,
  })  : _userSignup = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _globalBloc = globalBloc,
        _logOut = logOut,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) {
      emit(AuthLoading());
    });

    on<AuthSignup>(
      (event, emit) async {
        final res = await _userSignup.call(
          UserSignupParams(
            name: event.name,
            email: event.email,
            password: event.password,
          ),
        );
        return res.fold((l) => emit(AuthFailure(l.message)), (r) {
          _globalBloc.add(UpdateUser(r));
          emit(AuthSuccess(r));
        });
      },
    );

    on<AuthLogin>(
      (event, emit) async {
        final res = await _userLogin.call(
          UserLoginParams(
            email: event.email,
            password: event.password,
          ),
        );
        return res.fold((l) => emit(AuthFailure(l.message)), (r) {
          _globalBloc.add(UpdateUser(r));
          emit(AuthSuccess(r));
        });
      },
    );

    on<AuthUserLoggedInCheck>((event, emit) async {
      final res = await _currentUser();
      res.fold((l) => emit(AuthFailure(l.message)), (r) {
        _globalBloc.add(UpdateUser(r));
        emit(AuthSuccess(r));
      });
    });

    on<AuthLogoutEvent>((event, emit) async {
      final res = await _logOut();
      res.fold((l) => emit(AuthFailure(l.message)), (r) {
        _globalBloc.add(UpdateUser(null));
        emit(AuthInitial());
      });
    });
  }
}
