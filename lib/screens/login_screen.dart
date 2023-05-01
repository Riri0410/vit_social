import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vit_social/resources/auth_methods.dart';
import 'package:vit_social/utils/colors.dart';
import 'package:vit_social/utils/utils.dart';
import 'package:vit_social/widgets/text_field_input.dart';
import 'package:vit_social/screens/signup_screen.dart';
import 'package:vit_social/responsive/responsive_layout_screen_layout.dart';
import 'package:vit_social/responsive/mobile_screen_layout.dart';
import 'package:vit_social/responsive/web_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "Successfully Logged In!") {
      showSnackBar("Successfully Logged In!", context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                )),
      );
    } else {
      showSnackBar(res, context);
    }
    ;
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
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
              height: 180,
            ),
            const SizedBox(
              height: 82,
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
              height: 48,
            ),
            InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Log In'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: loginButtonColorBG),
                )),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Don't have an Account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: Text(
                        " Sign Up Here!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    )),
                SizedBox(
                  height: 256,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
