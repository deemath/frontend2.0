import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthService _authService;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the auth service with the provider
    _authService = AuthService(
        authProvider: Provider.of<AuthProvider>(context, listen: false));
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        final response = await _authService.login(email, password);

        if (response['success']) {
          // Print success message to console
          print('Login successful: ${response['message']}');

          // Check if user is authenticated in auth provider
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          if (authProvider.isAuthenticated && authProvider.user != null) {
            print('User authenticated: ${authProvider.user!.name}');
            // Navigate to home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            print('Authentication failed: User not stored in AuthProvider');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error occurred in authentication process')),
            );
          }
        } else {
          // Show error message
          print('Login failed: ${response['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        print('Login error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during login')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
              ),

              // Email Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    // labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                    // prefixIcon: Icon(LucideIcons.mail, color: Colors.grey),
                    fillColor: Color(0xFF212121),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xFF424242)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xFF424242)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    // labelText: 'Password',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                    // prefixIcon: Icon(LucideIcons.lock, color: Colors.grey),
                    fillColor: Color(0xFF212121),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xFF424242)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xFF424242)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot password functionality would go here
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Don't have an account button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to sign up page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                  ),
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
