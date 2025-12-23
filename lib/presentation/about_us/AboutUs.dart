import 'package:chess_game/core/constants/utils/themeSwitchButton.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/la.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  final String githubUrl = "https://github.com/Dada6x";
  final String linkedinUrl = "https://linkedin.com/in/yahea-dada-b03682370/";

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildLinkButton(String label, String url, Widget icon, Color color) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () => _launchURL(url),
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> get projects => [
        {
          "title": "EasyRent",
          "description":
              "A cross-platform mobile app that simplifies property discovery, listing, and renting. Built with Flutter, Dart, and GetX, integrated with Firebase and Stripe for payments. Features include advanced filtering, interactive maps, 360° panoramic property views, secure payments, and smooth animations for a modern user experience.",
          "image": "assets/images/easyrent.png",
          "link": "https://github.com/Dada6x/easyrent"
        },
        {
          "title": "Habit Tracker.",
          "description":
              "A productivity app that tracks daily habits with a clean calendar UI. Built using Flutter and Laravel backend.",
          "image": "assets/images/habitly.png",
          "link": "https://github.com/Dada6x/Monumental-habits",
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [ThemeSwitchButton()],
        leading: BackButton(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: Text(
          "About The Developer",
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 20,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
              const SizedBox(height: 16),
              Text(
                "Yahiea Dada",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Third Year Student at \nDamascus University",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // About App
              Card(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About this App",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "This chess app was developed by me using Supabase for backend storage and authentication, "
                        "combined with the Squares FEN library to handle chess moves and board state. "
                        "It allows multiplayer chess games in real-time with smooth updates and rich UI.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Links
              Row(
                children: [
                  _buildLinkButton(
                    "GitHub",
                    githubUrl,
                    const Iconify(La.github_alt, color: Colors.white, size: 30),
                    Colors.black87,
                  ),
                  const SizedBox(width: 16),
                  _buildLinkButton(
                    "LinkedIn",
                    linkedinUrl,
                    const Iconify(La.linkedin, color: Colors.white, size: 30),
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Projects",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Generate project cards
              Column(
                children: projects.map((project) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              project["image"]!,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project["title"]!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  project["description"]!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        _launchURL(project["link"]!),
                                    child: const Text("View Project →"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
