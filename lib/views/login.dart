import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Z- Collector")),
      body: LoginPageForm(),
    );
  }
}

class LoginPageForm extends StatelessWidget {
  final _loginImage =
      "https://img.freepik.com/free-vector/isometric-data-protection-concept-with-parent-child-login-window-lock-3d_1284-63713.jpg";
  final _formKey = GlobalKey<FormBuilderState>();

  LoginPageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            Image.network(_loginImage),
            const SizedBox(height: 8),
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                label: Text('Email Address'),
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.email(context),
                FormBuilderValidators.required(context),
              ]),
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
            const Divider(),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _handleSubmit(context),
              child: const Text("Submit"),
            ),
            TextButton(
                onPressed: () => _handleRegister(context),
                child: const Text("Don't have an account? Register Now"))
          ],
        ),
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    Navigator.popAndPushNamed(context, '/register');
  }

  void _handleSubmit(BuildContext context) async {
    final formState = _formKey.currentState;
    if (formState == null) return;

    final isValid = formState.validate();
    if (!isValid) return;
    formState.save();

    try {
      final String email = formState.value['email'];
      final String password = formState.value['password'];
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.popAndPushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Something went wrong!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }
}
