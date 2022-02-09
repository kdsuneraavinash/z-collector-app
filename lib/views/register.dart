import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:z_collector_app/models/user.dart';
import 'package:z_collector_app/providers/progress_provider.dart';
import 'package:z_collector_app/views/helpers/snackbar_messages.dart';
import 'package:z_collector_app/views/helpers/progress_overlay.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Z- Collector Register")),
      body: ProgressOverlay(child: RegisterPageForm()),
    );
  }
}

class RegisterPageForm extends ConsumerWidget {
  final _registerImage = "https://www.dc10g.com/image/login_des.png";
  final _formKey = GlobalKey<FormBuilderState>();

  RegisterPageForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  onPressed: () => _handleSubmit(context, ref),
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
    Beamer.of(context).beamToNamed('/login');
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final String name = formState.value['name'];
    final String email = formState.value['email'];
    final String password = formState.value['password'];

    final progressNotifier = ref.read(progressProvider.notifier);
    progressNotifier.start();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = User(name: name, email: email);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set(user.toJson());
      Beamer.of(context).beamToNamed('/home');
    } on FirebaseAuthException catch (e) {
      showErrorMessage(context, e.message ?? 'Something went wrong!');
    } catch (e) {
      showErrorMessage(context, 'Something went wrong!');
    } finally {
      progressNotifier.stop();
    }
  }
}
