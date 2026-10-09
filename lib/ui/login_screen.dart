import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth});
  final AuthService auth;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false, _register = false;
  String? _error;

  Future<void> _submit() async {
    setState(() { _busy = true; _error = null; });
    try {
      final e = _email.text.trim(), p = _password.text;
      _register ? await widget.auth.register(e, p) : await widget.auth.signIn(e, p);
    } on FirebaseAuthException catch (ex) {
      setState(() => _error = switch (ex.code) {
        'network-request-failed' => 'No connection. Sign-in needs internet.',
        'invalid-credential' || 'wrong-password' || 'user-not-found' =>
            'Wrong email or password.',
        'email-already-in-use' => 'That email is already registered.',
        'weak-password' => 'Password must be at least 6 characters.',
        _ => ex.message ?? 'Something went wrong.',
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress),
                TextField(controller: _password, obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password')),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: Text(_register ? 'Create account' : 'Sign in'),
                ),
                TextButton(
                  onPressed: () => setState(() => _register = !_register),
                  child: Text(_register ? 'Have an account? Sign in' : 'New here? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}