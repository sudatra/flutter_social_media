import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/components/custom_text_field.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubits/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({
    super.key, 
    required this.user
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    if(bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if(state is ProfileLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading...")
                ],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      }, 
      listener: (context, state) {
        if(state is ProfileLoaded) {
          Navigator.pop(context);
        }
      }
    );
  }

  Widget buildEditPage({ double uploadProgress = 0.0 }) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Edit Profile")),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: updateProfile, 
            icon: Icon(Icons.upload)
          )
        ],
      ),
      body: Column(
        children: [
          Text("Bio"),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: CustomTextField(
              controller: bioTextController, 
              hintText: widget.user.bio, 
              obscureText: false
            ),
          )
        ],
      ),
    );
  }
}