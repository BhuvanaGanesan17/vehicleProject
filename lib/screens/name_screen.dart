import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vehicle/SQLite/database_helper.dart';

import 'numberof_wheel_screen.dart';

class NameFormScreen extends StatefulWidget {
  const NameFormScreen({super.key});

  @override
  State<NameFormScreen> createState() => NameFormScreenState();
}

class NameFormScreenState extends State<NameFormScreen> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  Future<void> saveIntermediateData() async {
    try {
      await DatabaseHelper.instance.saveData('first_name', nameController.text);
      await DatabaseHelper.instance.saveData('last_name', lastNameController.text);
      if (kDebugMode) {
        print('Intermediate data saved: First Name - ${nameController.text}, Last Name - ${lastNameController.text}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving intermediate data: $e');
      }
    }
  }

  Future<void> loadSavedData() async {
    try {
      final savedData = await DatabaseHelper.instance.fetchAllData();
      nameController.text = savedData['first_name'] ?? '';
      lastNameController.text = savedData['last_name'] ?? '';
      if (kDebugMode) {
        print('Loaded saved data: $savedData');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading saved data: $e');
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Text(
          "Vehicle App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              CustomTextField(
                myController: nameController,
                fieldName: "Enter your FirstName",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Name is required';
                  } else if (value.length < 3) {
                    return 'First Name must be at least 3 characters';
                  }
                  else if (value.length > 15) {
                    return 'First Name must not be more than 15 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                myController: lastNameController,
                fieldName: "Enter your LastName",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Name is required';
                  } else if (value.length < 3) {
                    return 'Last Name must be at least 3 characters';
                  }
                  else if (value.length > 20) {
                    return 'Last Name must not be more than 20 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              myBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget myBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (formKey.currentState?.validate() ?? false) {
          await saveIntermediateData();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NumberOfWheelScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please fix the errors')),
          );
        }
      },
      child: Container(
        width: 200,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade400, // Button background color
          borderRadius: BorderRadius.circular(25), // Adjust the radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Optional shadow effect
              blurRadius: 4,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Text(
          "Next".toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
      ),
    );
  }





}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.fieldName,
    required this.myController,
    this.validator, // Add validator parameter
  });

  final TextEditingController myController;
  final String fieldName;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        labelText: fieldName,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple.shade400),
        ),
        labelStyle: const TextStyle(color: Colors.deepPurple),
      ),
      validator: validator,
    );
  }
}
