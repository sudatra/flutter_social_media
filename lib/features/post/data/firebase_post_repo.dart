
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/post/domain/entities/post.dart';
import 'package:social_media_app/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection("posts");

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot = await postsCollection.orderBy("timestamp", descending: true).get();
      final List<Post> allPosts = postsSnapshot
        .docs.map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList()
      ;

      return allPosts;
    } catch(error) {
      throw Exception("Error fetching all posts: $error");
    }
  }

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection
        .doc(post.id)
        .set(post.toJson())
      ;
    } catch(error) {
      throw Exception("Error creating post: $error");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection
        .doc(postId)
        .delete()
      ;
    } catch(error) {
      throw Exception("Error deleting post: $error");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final postsSnapshot = await postsCollection
        .where("userId", isEqualTo: userId)
        .orderBy("timestamp", descending: true)
        .get()
      ;
      final List<Post> allPostsByUserId = postsSnapshot
        .docs.map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList()
      ;

      return allPostsByUserId;
    } catch(error) {
      throw Exception("Error fetching all posts by user: $error");
    }
  }
}