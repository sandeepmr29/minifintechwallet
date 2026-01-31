import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    /// Login event
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.login(event.email, event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    /// Logout event
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logout();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}