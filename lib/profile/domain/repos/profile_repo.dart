
import 'package:social_media_app/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);

  Future<ProfileUser?> updateProfile(ProfileUser updatedProfile);
}