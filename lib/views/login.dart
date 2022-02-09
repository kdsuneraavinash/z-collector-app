import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:z_collector_app/providers/progress_provider.dart';
import 'package:z_collector_app/views/helpers/snackbar_messages.dart';
import 'package:z_collector_app/views/helpers/progress_overlay.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Z- Collector Login")),
      body: ProgressOverlay(child: LoginPageForm()),
    );
  }
}

class LoginPageForm extends ConsumerWidget {
  final _loginImage =
      "https://imgs.bharatmatrimony.com/bmimgs/login/login-otp-banner.png";
  final _formKey = GlobalKey<FormBuilderState>();

  LoginPageForm({Key? key}) : super(key: key);

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
                Image.network(_loginImage),
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
                  onPressed: () => _handleRegister(context),
                  child: const Text("Don't have an account? Register Now"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    Beamer.of(context).beamToNamed('/register');
  }

  void _handleSubmit(BuildContext context, WidgetRef ref) async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) return;
    formState.save();

    final String email = formState.value['email'];
    final String password = formState.value['password'];

    final progressNotifier = ref.read(progressProvider.notifier);
    progressNotifier.start();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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
