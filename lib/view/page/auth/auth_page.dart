import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sophia_hub/view/animation/route_change_anim.dart';
import 'package:sophia_hub/view/base_container.dart';
import 'package:sophia_hub/view/page/auth/forgot/forgot_pwd.dart';
import 'package:sophia_hub/view/page/auth/login.dart';
import 'package:sophia_hub/view/page/auth/register.dart';
import 'package:sophia_hub/view/page/auth/welcome.dart';

class AuthPage extends StatefulWidget {
  static const String nameRoute = "/";

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (BuildContext context) {
      return AuthPage();
    });
  }

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      // wrong call in wrong place!
      Navigator.of(context,rootNavigator: true).pushNamedAndRemoveUntil(BaseContainer.nameRoute,
              (route) => route.settings.name == AuthPage.nameRoute);
     return;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
                inputDecorationTheme:
                    Theme.of(context).inputDecorationTheme.copyWith(
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                        )),
            child: Navigator(
              initialRoute: Welcome.nameRoute,
              onGenerateRoute: (settings) {
                //Read more in the link below
                // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
                Widget wiget = Container();
                switch (settings.name) {
                  case Welcome.nameRoute:
                    wiget = const Welcome();
                    break;
                  case LoginView.routeName:
                    wiget = const LoginView();
                    break;
                  case RegisterView.routeName:
                    wiget = const RegisterView();
                    break;
                  case ForgotPwd.routeName:
                    wiget = ForgotPwd();
                    break;
                  default:
                    assert(false, 'Need to implement ${settings.name}');
                }

                return RouteAnimation.buildDefaultRouteTransition(
                    wiget, settings);
              },
            ),
          ),
        ));
  }



}
