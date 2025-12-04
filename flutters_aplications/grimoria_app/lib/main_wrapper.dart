import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'pages/auth/login_screen.dart';
import 'pages/home/home_screen.dart';
import 'pages/campaigns/campaigns_list.dart';
import 'pages/tools/dice_roller.dart';
import 'pages/profile/profile_screen.dart';
import 'pages/campaigns/create_campaign.dart';
import 'pages/campaigns/campaigns_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RpgManagerApp());
}

class RpgManagerApp extends StatelessWidget {
  const RpgManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPG Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/campaigns': (context) => const CampaignsListScreen(),
        '/tools': (context) => const ToolsScreen(),
        '/create-campaign': (context) => const CreateCampaignScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/campaign-detail') {
          final campaignId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CampaignDetailScreen(campaignId: campaignId),
          );
        }
        return null;
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, show main app
          return MainScreen(key: UniqueKey());
        } else {
          // User is not logged in, show login screen
          return const LoginScreen();
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const CampaignsListScreen(),
    const ToolsScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.groups,
    Icons.casino,
    Icons.person,
  ];

  final List<String> _titles = [
    'Início',
    'Campanhas',
    'Ferramentas',
    'Perfil',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        // O estilo visual foi definido no ThemeData acima para manter o código limpo
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Campanhas',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino),
            label: 'Ferramentas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
