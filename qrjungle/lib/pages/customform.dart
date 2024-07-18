import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom QR Details', style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              const Text(
                "What's your/your company's name?",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              TextField(
                maxLength: 25,
                style: const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please provide your phone number.",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              TextField(
                style: const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                decoration: const InputDecoration(
                  hintText: 'We\'ll email you if you cannot provide one.',
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 16),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Describe how you'll use your QR.",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              TextField(
                maxLength: 100,
                maxLines: 3,
                style: const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                decoration: InputDecoration(
                  hintText: 'This is for our team to understand what you need.',
                  hintStyle: const TextStyle(color: Colors.white60, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "How many QRs do you need?",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(height: 60),
              TextButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Center(
                      child: Text('Submit',
                          style: const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF))),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
