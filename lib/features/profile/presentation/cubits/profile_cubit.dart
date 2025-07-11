import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo
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

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = profileRepo.fetchUserProfile(uid);
    return user;
  } 
  
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath
  }) async {
    try {
      emit(ProfileLoading());
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if(currentUser == null) {
        emit(ProfileErrors("Failed to fetch user to update"));
      }

      String? imageDownloadUrl;
      if(imageWebBytes != null || imageMobilePath != null) {
        if(imageMobilePath != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        } else if(imageWebBytes != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if(imageDownloadUrl == null) {
          emit(ProfileErrors("Failed to upload image"));
          return;
        }
      }

      final updatedProfile = currentUser?.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl
      );
      
      await profileRepo.updateProfile(updatedProfile!);
      await fetchUserProfile(uid);
    } catch(error) {
      emit(ProfileErrors("Error updating profile: $error"));
    }
  }

  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
      await fetchUserProfile(targetUserId);
    } catch(error) {
      emit(ProfileErrors("Error toggling profile follow: $error"));
    }
  }
}