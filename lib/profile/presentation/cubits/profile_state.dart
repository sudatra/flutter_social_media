
import 'package:social_media_app/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUser? profileUser;
  ProfileLoaded(this.profileUser);
}

class ProfileErrors extends ProfileState {
  final String message;
  ProfileErrors(this.message);
}