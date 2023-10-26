import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/screens/ar_camera.dart';
import 'package:teslo_shop/features/products/presentation/screens/loading_screen.dart';

import 'package:teslo_shop/features/products/presentation/screens/maps_screen.dart';
import 'package:teslo_shop/features/products/presentation/screens/products_screen_user.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

import '../../features/auth/presentation/screens/screens.dart';

import '../../features/products/presentation/screens/commets_screen.dart';
import '../../features/products/presentation/screens/screens.dart';
import 'app_router_notfier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNitifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Auth Routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatus(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      ///
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/user',
        builder: (context, state) => const ProductsUserScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.params['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/user/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.params['id'] ?? 'no-id',
        ),
      ),
      //map
      GoRoute(
        path: '/map/:latitude/:longitude',
        builder: (context, state) {
          final lat = double.parse(state.params['latitude'] ?? '0.0');
          final log = double.parse(state.params['longitude'] ?? '0');

          return MapsScreen(lat: lat, lng: log);
        },
      ),
      // video
      GoRoute(
        path: '/video',
        builder: (context, state) =>
            const VideoReproductorScreen(video: 'video'),
      ),
      //comments
      GoRoute(
        path: '/comments/:id',
        builder: (context, state) => CommentScreen(
          commetID: state.params['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/arcamera',
        builder: (context, state) => ArCamera(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      final authState = ref.read(authProvider);
      final user = authState.user;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAunthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          if (user?.isAdmin ?? false) {
            // Redirige al usuario a una ruta específica para admin
            return '/';
          } else {
            return '/user';
          }
        }
      }

      ////hacer otra condicion cuando el rol sea diferente
      ///llamar ala provider donde se encuentra el isAdimn

      return null;
    },
  );
});
