import 'package:fbus_app/src/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
