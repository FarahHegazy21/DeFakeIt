import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = 'Rose';
    final email = 'Rose@gmail.com';
    final totalAudios = 7;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Profile',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Image.asset("assets/images/edit_user.png",
                  width: 24, height: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
          const SizedBox(height: 20),
          Text(username,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                ListTile(
                  title: Text('Email Address',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textColorLightGray,
                            fontWeight: FontWeight.bold,
                          )),
                  trailing: Text(email,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black)),
                ),
                const Divider(),
                const SizedBox(height: 15),
                ListTile(
                  title: Text('Total Audios',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textColorLightGray,
                            fontWeight: FontWeight.bold,
                          )),
                  trailing: Text('$totalAudios',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
