
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState>{
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({
    required this.authRepo
  }) : super(AuthInitial());

  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if(user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailAndPassword(email, password);

      if(user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
    } catch(e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailAndPassword(name, email, password);

      if(user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
    } catch(e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> logout() async {
    authRepo.logout();
    emit(UnAuthenticated());
  }
}