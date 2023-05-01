import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vit_social/resources/auth_methods.dart';
import 'package:vit_social/responsive/mobile_screen_layout.dart';
import 'package:vit_social/responsive/responsive_layout_screen_layout.dart';
import 'package:vit_social/responsive/web_screen.dart';
import 'package:vit_social/utils/colors.dart';
import 'package:vit_social/utils/utils.dart';
import 'package:vit_social/widgets/text_field_input.dart';
import 'package:vit_social/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != "Account Successfully Created!") {
      showSnackBar(res, context);
    } else {
      showSnackBar(
          "Account Successfully Created! Auto Signed In, Welcome!", context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                )),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(child: Container(), flex: 2),
            SvgPicture.asset(
              'assets/logo.svg',
              height: 128,
            ),
            const SizedBox(
              height: 12,
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://t3.ftcdn.net/jpg/05/17/79/88/360_F_517798849_WuXhHTpg2djTbfNf0FQAjzFEoluHpnct.jpg'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                      color: loginButtonColorBG,
                    ))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: "Name",
              textInputType: TextInputType.text,
              textEditingController: _nameController,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: "Username",
              textInputType: TextInputType.text,
              textEditingController: _usernameController,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: "Email Address",
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: "Password",
              textInputType: TextInputType.text,
              isPass: true,
              textEditingController: _passwordController,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFieldInput(
              hintText: "Bio",
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),
            const SizedBox(
              height: 48,
            ),
            InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text('SignUp'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: loginButtonColorBG),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Already have an Account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text(
                        " Sign In Here!",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    )),
                const SizedBox(
                  height: 140,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
