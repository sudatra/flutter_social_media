import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repos/post_repo.dart';
import 'package:social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo
  }) : super(PostInitial());

  Future<void> createPost(Post post, { String? imagePath, Uint8List? imageBytes }) async {
    try {
      String? imageUrl;

      if(imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageMobile(imagePath, post.id);
      } else if(imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadProfileImageWeb(imageBytes, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);
      postRepo.createPost(newPost);
    } catch(error) {
      emit(PostError("Failed to create post: $error"));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();

      emit(PostLoaded(posts));
    } catch(error) {
      emit(PostError("Failed to fetch all posts: $error"));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch(error) {
      emit(PostError("Failed to delete post: $error"));
    }
  }
}