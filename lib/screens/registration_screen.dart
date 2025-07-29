import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_managemet/model/user_model.dart';
import 'package:event_managemet/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // Editing Controllers
  final ClubNameEditingController = TextEditingController();
  final PresidentNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  // Error message holders
  String? ClubNameError;
  String? PresidentNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    // First name field
    final ClubNameField = TextFormField(
      autofocus: false,
      controller: ClubNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return "First Name cannot be Empty";
        }
        if (!regex.hasMatch(value)) {
          return "Enter Valid name (Min. 3 Characters)";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          ClubNameError = null;
        });
      },
      onSaved: (value) {
        ClubNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Club Name",
        errorText: ClubNameError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Second name field
    final PresidentNameField = TextFormField(
      autofocus: false,
      controller: PresidentNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "President Name cannot be Empty";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          PresidentNameError = null;
        });
      },
      onSaved: (value) {
        PresidentNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "President Name",
        errorText: PresidentNameError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Email";
        }
        // Reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please Enter a valid email";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          emailError = null;
        });
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        errorText: emailError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required for login";
        }
        if (!regex.hasMatch(value)) {
          return "Enter Valid Password (Min. 6 Characters)";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          passwordError = null;
        });
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        errorText: passwordError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Passwords don't match";
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          confirmPasswordError = null;
        });
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        errorText: confirmPasswordError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Sign-up button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 0, 0, 255),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            ClubNameError =
                ClubNameField.validator!(ClubNameEditingController.text);
            PresidentNameError = PresidentNameField
                .validator!(PresidentNameEditingController.text);
            emailError = emailField.validator!(emailEditingController.text);
            passwordError =
                passwordField.validator!(passwordEditingController.text);
            confirmPasswordError = confirmPasswordField
                .validator!(confirmPasswordEditingController.text);
          });

          if (_formKey.currentState!.validate()) {
            signUp(emailEditingController.text, passwordEditingController.text);
          }
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            // Passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(36.0, 0.1, 36.0, 36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding:
                          EdgeInsets.only(bottom: 10), // Adjust bottom padding
                      child: SizedBox(
                        height: 170,
                        child: Image.asset(
                          "assets/logo.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    ClubNameField,
                    SizedBox(height: 20),
                    PresidentNameField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 50),
                    signUpButton,
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFireStore()})
          // ignore: body_might_complete_normally_catch_error
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.clubName = ClubNameEditingController.text;
    userModel.PresidentName = PresidentNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
      (context),
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}
