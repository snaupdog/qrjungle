import 'package:flutter/material.dart';

class Testlogin extends StatelessWidget {
  const Testlogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              size: 30,
              Icons.home,
              color: Color(0xff969a2f),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF000000),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(80.0),
            child: Text(
              "QR JUNGLE",
              style: TextStyle(fontSize: 56.0, color: Color(0xff969a2f)),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white,
                    width: 2.0), // Change the color and width as needed
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 30.0,
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Enter a vaild email',
                        ),
                        //controller: emailController,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        //await signInCustomFlow();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF000000),
                        backgroundColor: const Color(0xff969a2f),
                      ),
                      child: const Text('Login'),
                    ),

                    const SizedBox(height: 20),

                    //if (!isvalid)
                    //  const Text(
                    //    "wrong username or password",
                    //  ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
