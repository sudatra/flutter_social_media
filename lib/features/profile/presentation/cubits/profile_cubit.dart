import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({
    required this.profileRepo
  }) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if(user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileErrors("User not found"));
      }
    } catch(error) {
      emit(ProfileErrors(error.toString()));
    }
  }
  
  Future<void> updateProfile({
    required String uid,
    String? newBio
  }) async {
    try {
      emit(ProfileLoading());
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if(currentUser == null) {
        emit(ProfileErrors("Failed to fetch user to update"));
      }

      final updatedProfile = currentUser?.copyWith(newBio: newBio ?? currentUser.bio);
      await profileRepo.updateProfile(updatedProfile!);
      await fetchUserProfile(uid);
    } catch(error) {
      emit(ProfileErrors("Error updating profile: $error"));
    }
  }
}