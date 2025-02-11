import 'dart:io';

import 'package:chat_app/logics/auth_logic.dart';
import 'package:chat_app/validators/auth_validator.dart';
import 'package:chat_app/widget/user_image_picker.dart';
import 'package:flutter/material.dart';

const authValidator = AuthValidator();
const authLogic = AuthLogic();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isAuthenticating = false;

  String _enteredEmail = '';
  String _enteredUsername = '';
  String _enteredPassword = '';
  File? _selectedImage;

  void _submit() async {
    setState(() {
      _isAuthenticating = true;
    });

    final isAllValid = _formKey.currentState!.validate();
    if (!isAllValid) return;
    if (!_isLogin && _selectedImage == null) return;

    _formKey.currentState!.save();

    final (userCredentials, authError) = await authLogic.submitAuth(
      email: _enteredEmail,
      password: _enteredPassword,
      username: _enteredUsername,
      isLogin: _isLogin,
      imageFile: _selectedImage,
    );
    if (authError != null && context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(authError.message ?? 'Authentication failed.'),
      ));
    }

    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) =>
                                  _selectedImage = pickedImage,
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: authValidator.validateEmail,
                            onSaved: (newValue) => _enteredEmail = newValue!,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              enableSuggestions: false,
                              validator: authValidator.validateUsername,
                              onSaved: (newValue) =>
                                  _enteredUsername = newValue!,
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: authValidator.validatePassword,
                            onSaved: (newValue) => _enteredPassword = newValue!,
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating) ...[
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
