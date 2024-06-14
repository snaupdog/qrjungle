import 'package:flutter/material.dart';
import 'package:qrjungle/main.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/mickey.png'),
                  radius: 70.0,
                ),
              ),
              Divider(
                height: 45,
                color: Color.fromARGB(255, 255, 224, 100),
              ),
              Text(
                'Name:',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 20,
                ),
              ),
              Text(
                'Shreerem Changloo',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 224, 28),
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ',
                style: TextStyle(
                  color: Colors.white60,
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
                    color: Colors.white60,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'shreeremc@gmail.com',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 224, 28),
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Switch(
                value: themeselector.thememode == ThemeMode.dark,
                onChanged: (newValue) {
                  themeselector.toggleTheme(newValue);
                }
              ),
              Text(
                'My QRs:',
                style: TextStyle(
                  color: Colors.amber,
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