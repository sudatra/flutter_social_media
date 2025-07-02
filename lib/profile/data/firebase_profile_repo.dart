
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firebaseFirestore
        .collection("users")
        .doc(uid)
        .get()
      ;

      if(userDoc.exists) {
        final userData = userDoc.data();
        if(userData != null) {
          return ProfileUser(
            uid: uid, 
            email: userData['email'], 
            name: userData['name'], 
            bio: userData['bio'] ?? '', 
            profileImageUrl: userData['profileImageUrl'].toString()
          );
        }
      }

      return null;
    } catch(error) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      await firebaseFirestore
        .collection("users")
        .doc(updatedProfile.uid)
        .update({
          'bio': updatedProfile.bio,
          'profileImageUrl': updatedProfile.profileImageUrl
        })
      ;
    } catch(error) {
      throw Exception(error);
    }
  }
}