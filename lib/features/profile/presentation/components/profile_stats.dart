import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(postCount.toString()),
              Text("Posts")
            ],
          ),
        ),

        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(followerCount.toString()),
              Text("Followers")
            ],
          ),
        ),

        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(followingCount.toString()),
              Text("Following")
            ],
          ),
        )
      ],
    );
  }
}