import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sturrd_flutter/home/home_screen.dart';

final kFirebaseAnalytics = FirebaseAnalytics();

class LoginSignupPage extends StatefulWidget {
  //const LoginSignupPage({Key key})
  static const kRouteName = '/RoutesExample';

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  FirebaseUser _user;

  bool _busy = false;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.currentUser().then(
          (user) => setState(() => this._user = user),
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final statusText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(_user == null
          ? 'You are not logged in.'
          : 'You are logged in as "${_user.displayName}".'),
    );

    final anonymousLoginBtn = MaterialButton(
        color: Colors.pink,
        child: Text('Log in anonymously'),
        onPressed: this._busy
            ? null
            : () async {
                setState(() => this._busy = true);
                final user = await this._anonymousSignIn();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                setState(() => this._busy = false);
              });

    final signOutBtn = FlatButton(
        child: Text('Log out'),
        onPressed: this._busy
            ? null
            : () async {
                setState(() => this._busy = true);
                await this._signOut();
                setState(() => this._busy = false);
              });

    return Center(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
        children: <Widget>[
          statusText,
          anonymousLoginBtn,
          signOutBtn,
        ],
      ),
    );
  }

  Future<FirebaseUser> _anonymousSignIn() async {
    final curUser = this._user ?? await FirebaseAuth.instance.currentUser();
    if (curUser != null && curUser.isAnonymous) {
      return curUser;
    }
    FirebaseAuth.instance.signOut();
    final anonyUser = (await FirebaseAuth.instance.signInAnonymously()).user;
    final userInfo = UserUpdateInfo();
    userInfo.displayName = '${anonyUser.uid.substring(0, 5)}_Guest';
    await anonyUser.updateProfile(userInfo);
    await anonyUser.reload();

    final user = await FirebaseAuth.instance.currentUser();
    kFirebaseAnalytics.logLogin();
    setState(() => this._user);
    return user;
  }

  Future<Null> _signOut() async {
    final user = await FirebaseAuth.instance.currentUser();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(user == null
            ? 'No user logged in.'
            : '"${user.displayName}" logged out.'),
      ),
    );
    FirebaseAuth.instance.signOut();
    setState(() => this._user = null);
  }
}
