import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:qrjungle/models/apiss.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _useCaseController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  late String nameinp;
  late String numinp;
  late String usecaseinp;
  late int qtyinp;

  @override
  void dispose() {
    _nameController.dispose();
    _numController.dispose();
    _useCaseController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

void _handleSubmit() async {
  String phoneNumber = _numController.text;
  if (phoneNumber.length != 10 && isNumeric(phoneNumber)) {
    Fluttertoast.showToast(
      msg: "Phone number must be 10 digits.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color.fromARGB(100, 158, 158, 158),
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  setState(() {
    nameinp = _nameController.text;
    numinp = phoneNumber;
    usecaseinp = _useCaseController.text;
    qtyinp = int.tryParse(_qtyController.text) ?? 0;
  });

  String desc = "Name: $nameinp, Use Case: $usecaseinp, Quantity: $qtyinp";
  print('Description: $desc');

  await Apiss().requestCustom(numinp, desc);
}

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
                controller: _nameController,
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
                controller: _numController,
                maxLength: 10,
                keyboardType: TextInputType.number,
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
                controller: _useCaseController,
                maxLength: 100,
                maxLines: 3,
                style: const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                decoration: InputDecoration(
                  hintText: 'This is for our team to understand what you need.',
                  hintStyle: const TextStyle(color: Colors.white60, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "How many QRs do you need?",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              TextField(
                controller: _qtyController,
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
                  onPressed: _handleSubmit,
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
