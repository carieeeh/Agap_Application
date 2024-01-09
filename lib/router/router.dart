import 'package:agap_mobile_v01/layout/private/homepage.dart';
import 'package:agap_mobile_v01/layout/public/login.dart';
import 'package:go_router/go_router.dart';

class RouteList {
  final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      // redirect: (BuildContext context, GoRouterState state) {
      //   final isAuthenticated =
      //       true; // your logic to check if user is authenticated
      //   if (!isAuthenticated) {
      //     return '/login';
      //   } else {
      //     return null; // return "null" to display the intended route without redirecting
      //   }
      // },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    )
  ],
);
}