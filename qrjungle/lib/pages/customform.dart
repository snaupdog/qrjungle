import 'package:flutter/material.dart';
import 'package:qrjungle/models/apiss.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _useCaseController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  late String nameinp;
  late String numinp;
  late String usecaseinp;
  late int qtyinp;
  late String desc;

  @override
  void dispose() {
    _nameController.dispose();
    _numController.dispose();
    _useCaseController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String phoneNumber = _numController.text;
      setState(() {
        nameinp = _nameController.text;
        numinp = phoneNumber;
        usecaseinp = _useCaseController.text;
        qtyinp = int.tryParse(_qtyController.text) ?? 0;
      });
      desc = "Name: $nameinp, Use Case: $usecaseinp, Quantity: $qtyinp";
      print('Description: $desc');

      await _requestForQR(numinp, desc);
    }
  }

  Future<void> _requestForQR(String number, String description) async {
    int response = await Apiss().requestCustom(number, description);
    if (response == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 21, 21, 21),
            title: const Text("Request successfully sent!",
                style: TextStyle(fontWeight: FontWeight.w600)),
            content: const Text("Our team will contact you soon!",
                style: TextStyle(fontSize: 16)),
            actions: [
              TextButton(
                child: const Text("Okay",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Pop back to the previous page
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle error response if needed
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "What's your/your company's name?",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                TextFormField(
                  controller: _nameController,
                  maxLength: 25,
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please provide your phone number.",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                TextFormField(
                  controller: _numController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (value.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                const Text(
                  "Describe how you'll use your QR.",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _useCaseController,
                  maxLength: 100,
                  maxLines: null, // Allows the field to expand as needed
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                  decoration: const InputDecoration(
                    hintText:
                        'This is for our team to understand what you need.',
                    hintStyle: TextStyle(color: Colors.white60, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "How many QRs do you need?",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                TextFormField(
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF6CCEFF)),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 60),
                TextButton(
                  onPressed: _handleSubmit,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Center(
                      child: Text('Submit',
                          style: TextStyle(
                              fontSize: 21, color: Color(0xFF6CCEFF))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
