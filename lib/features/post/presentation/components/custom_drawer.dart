import 'package:flutter/material.dart';
import 'package:social_media_app/features/post/presentation/components/custom_drawer_tile.dart';

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
                onTap: () {}
              ),
          
              CustomDrawerTile(
                title: "P R O F I L E", 
                icon: Icons.search, 
                onTap: () {}
              ),
          
              CustomDrawerTile(
                title: "S E T T I N G S", 
                icon: Icons.settings, 
                onTap: () {}
              ),
          
              const Spacer(),
              CustomDrawerTile(
                title: "L O G O U T", 
                icon: Icons.logout, 
                onTap: () {}
              ),
            ],
          ),
        ),
      ),
    );
  }
}