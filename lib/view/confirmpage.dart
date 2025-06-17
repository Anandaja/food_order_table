import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:order_now_android/view/landingpage.dart';


class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  State<ConfirmPage> createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          //  shrinkWrap: true,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: Lottie.asset(
                'assets/animation/Green tick.json',
                //   repeat: false,
                fit: BoxFit.contain,
                onLoaded: (p0) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ),
            isLoading
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Order ',
                        style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                fontSize: 28,
                                color: Color.fromARGB(255, 32, 32, 32),
                                fontWeight: FontWeight.w400)),
                      ),
                      Text(
                        'Confirmed',
                        style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                fontSize: 28,
                                color: Color.fromARGB(255, 7, 184, 60),
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
            SizedBox(
              height: 30,
            ),
            isLoading
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      //backing to the landing page
                      //also when try to open the drop down again, it just loads many table no 's
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => LandingPage()),
                          (route) => false);
                      print('pressed');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0)),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
