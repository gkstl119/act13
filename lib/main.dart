import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: AuthenticationScreen(),
    );
  }
}

// New AuthenticationScreen as the entry point for authentication
class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate screen for user registration
class RegisterScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: RegisterForm(
          authService: _authService,
          onRegisterSuccess: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'Home')),
            );
          }),
    );
  }
}

// Separate screen for user sign-in
class SignInScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: SignInForm(
          authService: _authService,
          onSignInSuccess: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'Home')),
            );
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Signed out successfully'),
    ));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthenticationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: _signOut,
            child: Text('Sign Out'),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the home screen!'),
      ),
    );
  }
}

// ProfileScreen to display user email and enable password change and logout
class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthenticationScreen()),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    final TextEditingController _passwordController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: "New Password"),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _auth.currentUser
                      ?.updatePassword(_passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password changed successfully")),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password change failed")),
                  );
                }
              },
              child: Text("Change"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _auth.currentUser?.email ?? 'No email';

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as: $userEmail"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text("Change Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onRegisterSuccess;

  RegisterForm(
      {Key? key, required this.authService, required this.onRegisterSuccess})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSuccessful = false;
  String? _message;

  void _register() async {
    var user = await widget.authService.registerWithEmail(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      widget.onRegisterSuccess(); // Redirect on success
    } else {
      setState(() {
        _isSuccessful = false;
        _message = 'Registration failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _register();
              }
            },
            child: Text('Register'),
          ),
          if (_message != null)
            Text(
              _message!,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onSignInSuccess;

  SignInForm(
      {Key? key, required this.authService, required this.onSignInSuccess})
      : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSuccessful = false;
  String? _message;

  void _signIn() async {
    var user = await widget.authService.signInWithEmail(
      _emailController.text,
      _passwordController.text,
    );
    if (user != null) {
      widget.onSignInSuccess(); // Redirect on success
    } else {
      setState(() {
        _isSuccessful = false;
        _message = 'Sign in failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _signIn();
              }
            },
            child: Text('Sign In'),
          ),
          if (_message != null)
            Text(
              _message!,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}

// AuthService class for Firebase Authentication operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in registration: $e");
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error in sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
