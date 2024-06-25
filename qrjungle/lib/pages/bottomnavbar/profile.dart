import 'package:flutter/material.dart';
import 'package:qrjungle/models/apis_graph.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  Future<void> fetchUrls() async {
    try {
      await ApissGraph().listFavourites();
      // await ApissGraph().addFavourites(["pJRx", "ga3e"]);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo.png', height: 200)),
              const Divider(
                height: 45,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              TextButton.icon(
                onPressed: () {},
                label: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(Icons.info_outline,
                    color: Color.fromARGB(255, 255, 255, 255)),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 32, 32, 32)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {},
                label: const Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
                icon: const Icon(Icons.info_outline,
                    color: Color.fromARGB(255, 255, 255, 255)),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 32, 32, 32)),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: ',
                style: TextStyle(
                  color: Color.fromARGB(153, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.email,
                    size: 30,
                    color: Color.fromARGB(153, 255, 255, 255),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'shreeremc@gmail.com',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const SizedBox(height: 25),
              const Text(
                'My QRs:',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void ShowModalSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        TextTheme textTheme = Theme.of(context).textTheme;
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 17, 0, 0),
                  child: Text('Categories', style: textTheme.bodyLarge),
                ),
                const SizedBox(height: 15),
                ListTile(
                    leading: const Icon(Icons.sports_basketball),
                    title: Text('Sports', style: textTheme.bodyMedium),
                    onTap: () {}),
                ListTile(
                    leading: const Icon(Icons.fastfood),
                    title: Text('Food', style: textTheme.bodyMedium),
                    onTap: () {}),
                ListTile(
                  leading: const Icon(Icons.wifi),
                  title: Text('Technology', style: textTheme.bodyMedium),
                  onTap: () {},
                ),
                ListTile(
                    leading: const Icon(Icons.book),
                    title: Text('Education', style: textTheme.bodyMedium),
                    onTap: () {}),
                ListTile(
                    leading: const Icon(Icons.more_horiz),
                    title: Text('More', style: textTheme.bodyMedium),
                    onTap: () {}),
              ],
            ),
          ),
        );
      });
}
