import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/diary_list_view.dart';
import 'views/add_edit_diary_entry_view.dart';
import 'views/signup_view.dart';
import 'views/forgot_password_view.dart';
import 'models/diary_entry_model.dart';
import 'providers/theme_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
        '/forgotPassword': (context) =>  ForgotPasswordView(),
        '/diaryList': (context) => DiaryListView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/addEditDiary') {
          final DiaryEntry? entry = settings.arguments as DiaryEntry?;
          return MaterialPageRoute(
            builder: (context) => AddEditDiaryEntryView(entry: entry),
          );
        }
        return null;
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return DiaryListView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
