import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qrjungle/models/apis.dart';

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
      await Apiss().listCustomers();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo.png', height: 200)),
              Divider(
                height: 45,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              TextButton.icon(
                onPressed: () {},
                label: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
                icon: Icon(Icons.info_outline,
                    color: Color.fromARGB(255, 255, 255, 255)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 32, 32, 32)),
                ),
              ),
              SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {},
                label: Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                ),
                icon: Icon(Icons.info_outline,
                    color: Color.fromARGB(255, 255, 255, 255)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 32, 32, 32)),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ',
                style: TextStyle(
                  color: Color.fromARGB(153, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.email,
                    size: 30,
                    color: const Color.fromARGB(153, 255, 255, 255),
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
              SizedBox(height: 25),
              SizedBox(height: 25),
              Text(
                'My QRs:',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
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
        TextTheme _textTheme = Theme.of(context).textTheme;
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(14, 17, 0, 0),
                  child: Text('Categories', style: _textTheme.bodyLarge),
                ),
                SizedBox(height: 15),
                ListTile(
                    leading: Icon(Icons.sports_basketball),
                    title: Text('Sports', style: _textTheme.bodyMedium),
                    onTap: () {}),
                ListTile(
                    leading: Icon(Icons.fastfood),
                    title: Text('Food', style: _textTheme.bodyMedium),
                    onTap: () {}),
                ListTile(
                  leading: Icon(Icons.wifi),
                  title: Text('Technology', style: _textTheme.bodyMedium),
                  onTap: () {},
                ),
                ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Education', style: _textTheme.bodyMedium),
                    onTap: () {}),
                ListTile(
                    leading: Icon(Icons.more_horiz),
                    title: Text('More', style: _textTheme.bodyMedium),
                    onTap: () {}),
              ],
            ),
          ),
        );
      });
}
