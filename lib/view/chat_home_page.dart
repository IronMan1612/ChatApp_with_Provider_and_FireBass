import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:provider_and_firebase/view/let_us_chat.dart';
import '../model/state_of_application.dart';
import '../controller/authenticate_to_firebase.dart';
import '../controller/all_widgets.dart';
class ChatHomePage extends StatelessWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF0078FF), // Messenger blue color
        title: const Text(
          'Messenger',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(
            // A sample user avatar. Replace with actual user's photo.
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2017/10/04/11/58/messenger-2815966_1280.jpg'),
            radius: 20,
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Container(
            height: 120, // Bạn có thể thay đổi chiều cao này để điều chỉnh kích thước logo
            width: 120,  // Tương tự, điều chỉnh chiều rộng logo tại đây
            padding: EdgeInsets.all(9),
            child: Image.network(
              'https://cdn.pixabay.com/photo/2016/07/03/18/35/messenger-1495274_1280.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Consumer<StateOfApplication>(
            builder: (context, appState, _) => AuthenticationForFirebase(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword:
              appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Center(
            child: const Text(
              "Let's Chat for a While",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: const Text(
              'Join your friends and chat for a while!',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Consumer<StateOfApplication>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Full width button
              children: [
                if (appState.loginState == UserStatus.loggedIn) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0078FF),
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LetUsChat(
                            addMessage: (message) =>
                                appState.addMessageToChatBook(message), messages: [],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Let\'s Chat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
