import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/components/custom_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  final captionController = TextEditingController();
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb
    );

    if(result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if(kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  void uploadPost() {
    if(imagePickedFile == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both Image and Caption are required"))
      );

      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      userId: currentUser!.uid, 
      userName: currentUser!.name, 
      text: captionController.text, 
      imageUrl: '', 
      timestamp: DateTime.now()
    );
    final postCubit = context.read<PostCubit>();

    if(kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    } else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if(state is PostLoading || state is PostUploading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return buildUploadPage();
      }, 
      listener: (context, state) {
        if(state is PostLoaded) {
          Navigator.pop(context);
        }
      }
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Upload Post")),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          children: [
            if(kIsWeb && webImage != null)
              Image.memory(webImage!),

            if(!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            MaterialButton(
              onPressed: pickImage,
              color: Colors.blue,
              child: const Text("Pick Image"),
            ),

            CustomTextField(
              controller: captionController, 
              hintText: "Caption", 
              obscureText: false
            )
          ],
        ),
      ),
    );
  }
}