import 'package:all_in_order/generated/l10n.dart';
import 'package:all_in_order/modules/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final profile = Provider.of<AuthService>(context).profile!;

    print(Intl.getCurrentLocale());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text("My Profile"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.redAccent[50],
                    child: Text(profile.name[0],
                        style: const TextStyle(fontSize: 60)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.redAccent[100],
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(profile.name,
                  style: Theme.of(context).textTheme.headlineMedium),
              Text("@${profile.username}"),
              const SizedBox(height: 20),
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //         // backgroundColor: tPrimaryColor,
              //         side: BorderSide.none,
              //         shape: const StadiumBorder()),
              //     child: const Text("Edit Profile"),
              //   ),
              // ),
              // const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Settings",
                icon: Icons.settings,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Language",
                icon: Icons.translate,
                onPress: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Select Language"),
                        content: SizedBox(
                          height: 168,
                          child: Column(
                            children: [
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text("English"),
                                onTap: () => _setLocale(context, "en"),
                              ),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text("Español"),
                                onTap: () => _setLocale(context, "es"),
                              ),
                              ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text("Valenciá"),
                                onTap: () => _setLocale(context, "ca"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ProfileMenuWidget(
                title: "Manage Account",
                icon: Icons.person,
                onPress: () {},
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: Icons.info,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Logout",
                icon: Icons.logout,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setLocale(BuildContext context, String languageCode) {
    S.load(Locale(languageCode));
    Navigator.of(context).pop();
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? Colors.red : Colors.redAccent;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.chevron_right,
                size: 18.0,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
