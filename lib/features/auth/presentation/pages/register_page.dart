import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/components/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/components/custom_text_field.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;

  const RegisterPage({
    super.key, 
    required this.togglePages
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final authCubit = context.read<AuthCubit>();

    if(
      name.isNotEmpty && 
      email.isNotEmpty && 
      password.isNotEmpty && 
      confirmPassword.isNotEmpty
    ) {
      if(password == confirmPassword) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Passwords do not match")
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please complete all the fields")
      ));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
            
                const SizedBox(height: 50),
                Text(
                  "Welcome, Create an account for yourself!!!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16
                  ),
                ),

                const SizedBox(height: 25),
                CustomTextField(
                  controller: nameController, 
                  hintText: 'Name', 
                  obscureText: false
                ),
            
                const SizedBox(height: 12),
                CustomTextField(
                  controller: emailController, 
                  hintText: 'Email', 
                  obscureText: false
                ),
            
                const SizedBox(height: 12),
                CustomTextField(
                  controller: passwordController, 
                  hintText: 'Password', 
                  obscureText: true
                ),

                const SizedBox(height: 12),
                CustomTextField(
                  controller: confirmPasswordController, 
                  hintText: 'Confirm Password', 
                  obscureText: true
                ),

                const SizedBox(height: 16),
                CustomButton(
                  text: 'Register',
                  onTap: register,
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),

                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        " Login now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}