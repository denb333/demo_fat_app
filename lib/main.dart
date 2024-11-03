import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fat_app/view/listlecturePage.dart';
import 'package:fat_app/view/Teacher/TeacherScreen.dart';
import 'package:fat_app/view/Teacher/TeacherScreenLive.dart';
import 'package:fat_app/view/UpdateInformationPage.dart';
import 'package:fat_app/view/payment/PaymentMethodScreen.dart';
import 'package:fat_app/view_auth/EmailVerify.dart';
import 'package:fat_app/view_auth/LoginPage.dart';
import 'package:fat_app/view/liveStreamPage.dart';
import 'package:fat_app/view/ClassSchedulePage.dart';
import 'package:fat_app/view/CoursePage.dart';
import 'package:fat_app/view/TutorListPage.dart';
import 'package:fat_app/view/InteractLearningPage.dart';
import 'package:fat_app/view_auth/RegisterView.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'constants/routes.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      livestreampage: (context) => LiveStreamPage(),
      classschedulePage: (context) => const ClassSchedulePage(),
      coursepage: (context) => const CoursePage(),
      fatutorpage: (context) => const TutorListPage(),
      interactlearningpage: (context) => const InteractLearningPage(),
      loginRoutes: (context) => const LoginView(),
      registerRoutes: (context) => const RegisterView(),
      emailverifyRoute: (context) => const EmailVerify(),
      paymentRoutes: (context) => PaymentMethodScreen(),
      updateinformationRoutes: (context) => UpdateInformationPage(),
      listlectureRoutes: (context) => ListLecturePage(),
      teacherliverecord: (context) => TeacherScreen(),
      teacherlive: (context) => TeacherScreenLive(cameras: cameras!),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.green,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/factutor_logo.png',
                  height: 80,
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/logo.png'),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset('images/students.png'),
                        const SizedBox(height: 5),
                        const Text('Students'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoutes, (route) => false);
                          },
                          child: const Text('Join Class'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 100),
                    Column(
                      children: [
                        Image.asset('images/tutor.png', height: 60),
                        const SizedBox(height: 10),
                        const Text('Tutor'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                interactlearningpage, (route) => false);
                          },
                          child: const Text('Join Class'),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Handle Facebook sign up
                      try {
                        final LoginResult result =
                            await FacebookAuth.instance.login();
                        if (result.status == LoginStatus.success) {
                          final userData =
                              await FacebookAuth.instance.getUserData();
                          print(userData);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoutes, (route) => false);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to sign up with Facebook'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.facebook),
                    label: const Text('Continue with Facebook'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            'LEARN WITH TUTOR',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
