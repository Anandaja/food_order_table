import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:order_now_android/firebase_options.dart';
// import 'package:order_now_android/view/homepage.dart';
// import 'package:order_now_android/view/landingpage.dart';
// import 'package:order_now_android/view_model/cartpage_view_medel.dart';
// import 'package:order_now_android/view_model/homepage_view_model.dart';
// import 'package:order_now_android/view_model/homepageuser_view_model.dart';
// import 'package:order_now_android/view_model/landing_page_view_model.dart';
// import 'package:order_now_android/view_model/order_details_view_model.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true); //is it want??
  // await FirebaseDatabase.instance.ref('tables').keepSynced(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         
      
        ChangeNotifierProvider<HomepageViewModel>(
            create: ((context) => HomepageViewModel())),
        ChangeNotifierProvider<OrderDetailsViewModel>(
            create: ((context) => OrderDetailsViewModel())),
            
  ChangeNotifierProvider<LandingpageViewModel>(
            create: ((context) => LandingpageViewModel())),
        ChangeNotifierProvider<HomepageuserViewModel>(
            create: ((context) => HomepageuserViewModel())),
        ChangeNotifierProvider<CartPageViewModel>(
            create: ((context) => CartPageViewModel()))
     
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //   textTheme: GoogleFonts.ralewayTextTheme(),
          textTheme: GoogleFonts.montserratTextTheme(), //which one??
          useMaterial3: true,
        ),
        home: LandingPage(),
        // home: MyHomePage(),
      ),
    );
  }
}
