import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/presentation/components/user_tile.dart';
import 'package:social_media_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:social_media_app/features/search/presentation/cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchQueryController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchQueryController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchQueryController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: TextField(
            controller: searchQueryController,
            decoration: InputDecoration(
              hintText: "Search Users...",
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          if(state is SearchLoaded) {
            if(state.users.isEmpty) {
              return const Center(
                child: Text("No Users found..."),
              );
            }

            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              }
            );
          } else if(state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text("Search for users..."),
            );
          }
        }
      ),
    );
  }
}