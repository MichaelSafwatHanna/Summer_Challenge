import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_challenge/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:summer_challenge/blocs/authentication_bloc/authentication_state.dart';
import 'package:summer_challenge/models/user.dart';
import 'package:summer_challenge/repositories/user_repository.dart';
import 'package:summer_challenge/screens/home_screen.dart';
import 'package:summer_challenge/screens/page_not_found.dart';
import 'package:summer_challenge/screens/sign_in_screen.dart';
import 'package:summer_challenge/screens/sign_up_screen.dart';
import 'package:summer_challenge/screens/splash_screen.dart';

class RouteConfiguration {
  static UserRepository userRepository;
  static User user;

  static Map<String, Widget Function(BuildContext, String)> paths = {
    "/posts": (context, match) => HomeScreen(user: user, page: "posts"),
    "/houses": (context, match) => HomeScreen(user: user, page: "houses"),
    "/scores": (context, match) => HomeScreen(user: user, page: "scores"),
    "/challenges": (context, match) =>
        HomeScreen(user: user, page: "challenges"),
    "/signin": (context, match) => SignInScreen(userRepository: userRepository),
    "/signup": (context, match) => SignUpScreen(userRepository: userRepository),
    "/": (context, match) => SplashScreen(),
    "/404": (context, match) => PageNotFound(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (!paths.containsKey(settings.name)) {
      return null;
    }
    String route = settings.name;

    return MaterialPageRoute<void>(
      builder: (context) {
        if (BlocProvider.of<AuthenticationBloc>(context).state
            is Unauthenticated) {
          settings = settings.copyWith(name: "/signin");
          route = "/signin";
        }

        if (settings.name == "/signin" || settings.name == "/signup") {
          if (BlocProvider.of<AuthenticationBloc>(context).state
              is Authenticated) {
            settings = settings.copyWith(name: "/posts");
            route = "/posts";
          }
        }
        return paths[route](context, route);
      },
      settings: settings,
    );
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (context) => paths["/404"](context, "/404"),
      settings: settings,
    );
  }
}

enum Page { HOUSES, Posts, Scores, Challenges }
