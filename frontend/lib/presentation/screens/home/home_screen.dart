import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_router.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Discover',
      'icon': Icons.explore,
    },
    {
      'title': 'Live',
      'icon': Icons.live_tv,
    },
    {
      'title': 'Favorites',
      'icon': Icons.favorite,
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title']),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.settings);
            },
          ),
          // Debug menu
          PopupMenuButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Debug Menu',
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'api_test',
                child: const Text('API Connection Test'),
                onTap: () {
                  // Need to use Future.delayed because the menu closes first
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).pushNamed(AppRouter.apiTest);
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: user?.isPerformer ?? false
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRouter.createStream);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _pages.map((page) {
          return BottomNavigationBarItem(
            icon: Icon(page['icon']),
            label: page['title'],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    // Placeholder content for each tab
    switch (_currentIndex) {
      case 0: // Discover
        return _buildDiscoverTab();
      case 1: // Live
        return _buildLiveTab();
      case 2: // Favorites
        return _buildFavoritesTab();
      case 3: // Profile
        return _buildProfileTab();
      default:
        return const Center(child: Text('Invalid tab'));
    }
  }

  Widget _buildDiscoverTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Discover Streams',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Find your favorite performers'),
        ],
      ),
    );
  }

  Widget _buildLiveTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv,
            size: 80,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Live Streams',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Currently streaming performers'),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Favorites',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Performers you follow'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture placeholder
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user?.username.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            
            // User info
            Text(
              user?.displayNameOrUsername ?? 'User',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? 'email@example.com',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Role: ${user?.role ?? 'viewer'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            
            // Edit profile button
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to edit profile
                Navigator.of(context).pushNamed(AppRouter.profile);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
            const SizedBox(height: 16),
            
            // Logout button
            ElevatedButton.icon(
              onPressed: () async {
                await authProvider.logout();
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed(AppRouter.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
