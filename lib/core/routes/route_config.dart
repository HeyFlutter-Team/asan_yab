import 'package:asan_yab/core/routes/routes.dart';
import 'package:asan_yab/presentation/pages/about_us_page.dart';
import 'package:asan_yab/presentation/pages/all_nearby_place.dart';
import 'package:asan_yab/presentation/pages/category_page.dart';
import 'package:asan_yab/presentation/pages/detials_page.dart';
import 'package:asan_yab/presentation/pages/doctors_page.dart';
import 'package:asan_yab/presentation/pages/list_category_item.dart';
import 'package:asan_yab/presentation/pages/main_page.dart';
import 'package:asan_yab/presentation/pages/message_page/chat_details_page.dart';
import 'package:asan_yab/presentation/pages/message_page/message_page.dart';
import 'package:asan_yab/presentation/pages/message_page/search_page.dart';
import 'package:asan_yab/presentation/pages/newitem_shop.dart';
import 'package:asan_yab/presentation/pages/offline_detials_page.dart';
import 'package:asan_yab/presentation/pages/profile/edit_profile_page.dart';
import 'package:asan_yab/presentation/pages/profile/list_of_follow.dart';
import 'package:asan_yab/presentation/pages/profile/other_profile.dart';
import 'package:asan_yab/presentation/pages/profile/profile_page.dart';
import 'package:asan_yab/presentation/pages/profile/show_profile_page.dart';
import 'package:asan_yab/presentation/pages/search_bar_page.dart';
import 'package:asan_yab/presentation/pages/sign_in_page.dart';
import 'package:asan_yab/presentation/pages/sign_up_page.dart';
import 'package:asan_yab/presentation/pages/suggestion_page.dart';
import 'package:asan_yab/presentation/pages/verify_email_page.dart';
import 'package:asan_yab/presentation/widgets/page_view_item_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/screen_image_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class RouteConfig {
  const RouteConfig._();
  static GoRouter router() => GoRouter(
        initialLocation: '/',
        navigatorKey: navigatorKey,
        observers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
        ],
        routes: [
          GoRoute(
            path: '/',
            name: Routes.home,
            pageBuilder: (context, state) => const MaterialPage(
              child: MainPage(),
            ),
          ),
          GoRoute(
            path: '/suggestion',
            name: Routes.suggestion,
            pageBuilder: (context, state) => const MaterialPage(
              child: SuggestionPage(),
            ),
          ),
          GoRoute(
            path: '/message',
            name: Routes.message,
            pageBuilder: (context, state) => const MaterialPage(
              child: MessagePage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: Routes.profile,
            pageBuilder: (context, state) => const MaterialPage(
              child: ProfilePage(),
            ),
          ),
          GoRoute(
            path: '/searchMessage',
            name: Routes.searchMessage,
            pageBuilder: (context, state) => const MaterialPage(
              child: SearchPage(),
            ),
          ),
          GoRoute(
            path: '/editProfile',
            name: Routes.editProfile,
            pageBuilder: (context, state) => const MaterialPage(
              child: EditProfilePage(),
            ),
          ),
          GoRoute(
            path: '/category',
            name: Routes.category,
            pageBuilder: (context, state) => const MaterialPage(
              child: CategoryPage(),
            ),
          ),
          GoRoute(
            path: '/aboutUs',
            name: Routes.aboutUs,
            pageBuilder: (context, state) => const MaterialPage(
              child: AboutUsPage(),
            ),
          ),
          GoRoute(
            path: '/listOfFollow',
            name: Routes.listOfFollow,
            pageBuilder: (context, state) =>
                const MaterialPage(child: ListOfFollow()),
          ),
          GoRoute(
            path: '/searchBar',
            name: Routes.searchBar,
            pageBuilder: (context, state) =>
                const MaterialPage(child: SearchBarPage()),
          ),
          GoRoute(
            path: '/signIn',
            name: Routes.signIn,
            pageBuilder: (context, state) =>
                const MaterialPage(child: SignInPage()),
          ),
          GoRoute(
            path: '/signUp',
            name: Routes.signUp,
            pageBuilder: (context, state) =>
                const MaterialPage(child: SignUpPage()),
          ),
          GoRoute(
            path: '/verifyEmail/:email',
            name: Routes.verifyEmail,
            pageBuilder: (context, state) {
              final email = state.pathParameters['email']!;
              return MaterialPage(child: VerifyEmailPage(email: email));
            },
          ),
          GoRoute(
            path: '/otherProfile',
            name: Routes.otherProfile,
            pageBuilder: (context, state) =>
                const MaterialPage(child: OtherProfile()),
          ),
          GoRoute(
            path: '/showProfile/:imageUrl',
            name: Routes.showProfile,
            pageBuilder: (context, state) {
              final imageUrl = state.pathParameters['imageUrl']!;
              return MaterialPage(child: ShowProfilePage(imageUrl: imageUrl));
            },
          ),
          GoRoute(
            path: '/chatDetail/:followId',
            name: Routes.chatDetail,
            pageBuilder: (context, state) {
              final followId = state.pathParameters['followId']!;
              return MaterialPage(child: ChatDetailPage(uid: followId));
            },
          ),
          GoRoute(
            path: '/details/:placeId',
            name: Routes.details,
            pageBuilder: (context, state) {
              final placeId = state.pathParameters['placeId']!;
              return MaterialPage(child: DetailsPage(id: placeId));
            },
          ),
          GoRoute(
            path: '/listOfCategory/:Id/:name',
            name: Routes.listOfCategory,
            pageBuilder: (context, state) {
              final id = state.pathParameters['Id']!;
              final name = state.pathParameters['name']!;
              return MaterialPage(
                child: ListCategoryItem(catId: id, categoryName: name),
              );
            },
          ),
          GoRoute(
            path: '/itemShop',
            name: Routes.itemShop,
            pageBuilder: (context, state) => const MaterialPage(
              child: ItemsSopping(),
            ),
          ),
          GoRoute(
            path: '/mageView',
            name: Routes.imageView,
            pageBuilder: (context, state) {
              return MaterialPage(
                  child: ImageView(
                arguments: state.extra as ScreenImageView,
              ));
            },
          ),
          GoRoute(
            path: '/doctors',
            name: Routes.doctors,
            pageBuilder: (context, state) => const MaterialPage(
              child: DoctorsPage(),
            ),
          ),
          GoRoute(
            path: '/offlineDetails/:favoritesItem',
            name: Routes.offlineDetails,
            pageBuilder: (context, state) {
              final favoritesItem = state.pathParameters['favoritesItem']!
                  as Map<String, dynamic>;
              return MaterialPage(
                child: OfflineDetailPage(favItem: favoritesItem),
              );
            },
          ),
          GoRoute(
            path: '/nearbyPlace',
            name: Routes.nearbyPlace,
            pageBuilder: (context, state) => const MaterialPage(
              child: NearbyPlacePage(),
            ),
          ),
        ],
      );
}
