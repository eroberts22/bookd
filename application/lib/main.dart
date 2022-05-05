import 'package:application/models/users.dart';
import 'package:application/screens/authenticate/landing_page.dart';
import 'package:application/screens/authenticate/sign_in.dart';
import 'package:application/screens/authenticate/register.dart';
import 'package:application/screens/homepage/account_venue.dart';
import 'package:application/screens/homepage/calendar_page.dart';
import 'package:application/screens/homepage/explore.dart';
import 'package:application/screens/homepage/account_artist.dart';
import 'package:application/screens/store_info/artist_store_info.dart';
import 'package:application/screens/store_info/venue_store_info.dart';
import 'package:application/screens/homepage/artist_profile_page.dart';
import 'package:application/screens/homepage/venue_profile_page.dart';
import 'package:application/screens/homepage/bookings.dart';
import 'package:application/screens/homepage/incoming_requests.dart';
import 'package:application/screens/homepage/home.dart';
import 'package:application/services/auth.dart';
import 'package:application/screens/store_info/upload_pictures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<BookdUser?>.value(
        // Uses the stream of BookdUser? objects from auth.dart
        initialData:
            null, // when dependencies were updated for no-null-safety, it wanted me to include initialData parameter, but I dodn't know what to put so I just did null
        value: AuthService().user,
        child: MaterialApp(
          initialRoute: Provider.of<BookdUser?>(context) == null
              ? LandingPage.routeName
              : '/home',
          routes: {
            LandingPage.routeName: (context) => const LandingPage(),
            Register.routeName: (context) => const Register(),
            SignIn.routeName: (context) => const SignIn(),
            '/home': (context) => const Home(),
            '/explore': (context) => const Explore(),
            '/profile-artist': (context) => const ProfileArtist(),
            '/profile-venue': (context) => const ProfileVenue(),
            '/account-artist': (context) => const AccountArtist(),
            '/account-venue': (context) => const AccountVenue(),
            '/artist-settings': (context) => const ArtistSettings(),
            '/venue-settings': (context) => const VenueSettings(),
            '/calendar': (context) => const CalendarPage(),
            '/upload-image': (context) => const UploadImage(),
            '/booking': (context) => const BookingPage(),
            '/incoming-requests': (context) => const IncomingRequestPage(),
          },
        ));
  }
}
