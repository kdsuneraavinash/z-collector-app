import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Z- Collector Register")),
      body: RegisterPageForm(),
    );
  }
}

class RegisterPageForm extends StatelessWidget {
  final _registerImage = "https://www.dc10g.com/image/login_des.png";
  final _formKey = GlobalKey<FormBuilderState>();

  RegisterPageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Image.network(_registerImage),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    label: Text('Name'),
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(context),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    label: Text('Email Address'),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.email(context),
                      FormBuilderValidators.required(context),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'retype_password',
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Retype Password'),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRetypePassword,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => _handleSubmit(context),
                  child: const Text("Submit"),
                ),
                TextButton(
                  onPressed: () => _handleLogin(context),
                  child: const Text("Already have an account? Login Now"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _validateRetypePassword(value) {
    if (value != _formKey.currentState?.fields['password']?.value) {
      return 'Password and Retype Password do not match';
    }
    return null;
  }

  void _handleLogin(BuildContext context) {
    Navigator.popAndPushNamed(context, '/login');
  }

  void _handleSubmit(BuildContext context) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final String name = formState.value['name'];
    final String email = formState.value['email'];
    final String password = formState.value['password'];

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({'email': email, 'name': name});
      Navigator.popAndPushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Something went wrong!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }
}
