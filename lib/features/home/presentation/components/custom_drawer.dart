import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/home/presentation/components/custom_drawer_tile.dart';
import 'package:social_media_app/profile/presentation/pages/profile_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary
                ),
              ),
          
              Divider(color: Theme.of(context).colorScheme.secondary),
              CustomDrawerTile(
                title: "H O M E", 
                icon: Icons.home, 
                onTap: () => Navigator.of(context).pop()
              ),
          
              CustomDrawerTile(
                title: "P R O F I L E", 
                icon: Icons.person, 
                onTap: () {
                  Navigator.of(context).pop();

                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid)
                    )
                  );
                }
              ),

              CustomDrawerTile(
                title: "S E A R C H", 
                icon: Icons.search, 
                onTap: () {
                  Navigator.of(context).pop();

                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid)
                    )
                  );
                }
              ),
          
              CustomDrawerTile(
                title: "S E T T I N G S", 
                icon: Icons.settings, 
                onTap: () {
                  Navigator.of(context).pop();

                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid)
                    )
                  );
                }
              ),
          
              const Spacer(),
              CustomDrawerTile(
                title: "L O G O U T", 
                icon: Icons.logout, 
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthCubit>().logout();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}