import 'package:go_router/go_router.dart';
import 'features/auth/onboarding_page.dart';
import 'features/home/home_page.dart';
import 'features/players/players_page.dart';
import 'features/players/view/player_details_page.dart';
import 'features/watchlist/watchlist_page.dart';
import 'features/settings/settings_page.dart';
import 'features/injuries/views/injuries_page.dart';
import 'features/my_team/my_team_pitch_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/my-team',
      name: 'my-team',
      builder: (context, state) => const MyTeamPage(),
    ),
    GoRoute(
      path: '/players',
      name: 'players',
      builder: (context, state) => const PlayersPage(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'player-details',
          builder: (ctx, st) {
            final id = int.parse(st.pathParameters['id']!);
            return PlayerDetailsPage(playerId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/watchlist',
      name: 'watchlist',
      builder: (context, state) => const WatchlistPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/injuries',
      name: 'injuries',
      builder: (ctx, st) => const InjuriesPage(),
    ),
  ],
);
