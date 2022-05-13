import 'package:application/screens/authenticate/register.dart';
import 'package:application/screens/authenticate/sign_in.dart';
import 'package:application/theme/app_theme.dart';
import 'package:application/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landingPage';
  const LandingPage({Key? key}) : super(key: key);
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Gradient Defined here
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const AppColors().primary,
                          const AppColors().secondary,
                          const AppColors().ternary
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 350),
                    child: Image.asset(
                      'assets/images/Bookd_landingpage_logo.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      color: Colors.white,
                      scale: 1.3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(SignIn.routeName),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(2),
                            overlayColor:
                                MaterialStateProperty.all(Colors.black12),
                            shadowColor:
                                MaterialStateProperty.all(Colors.pink.shade50),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            fixedSize:
                                MaterialStateProperty.all(const Size(412, 60)),
                          ),
                          child: Row(children: [
                            const Spacer(),
                            Text(
                              "SIGN IN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppTheme.colors.ternary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(Register.routeName),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(2),
                            overlayColor:
                                MaterialStateProperty.all(Colors.black12),
                            shadowColor:
                                MaterialStateProperty.all(Colors.pink.shade50),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            fixedSize:
                                MaterialStateProperty.all(const Size(412, 60)),
                          ),
                          child: Row(children: [
                            const Spacer(),
                            Text(
                              "REGISTER",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppTheme.colors.ternary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
