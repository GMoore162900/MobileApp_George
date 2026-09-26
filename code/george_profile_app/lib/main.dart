import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      drawer: const ProfileDrawer(),
      body: Center(
        child: Container(
          width: 360,
          height: 560,
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF3EA8E5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Builder(
                      builder: (ctx) => IconButton(
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                        icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              CircleAvatar(
                radius: 52,
                backgroundColor: const Color(0xFF4FA0D6),
                child: const Icon(Icons.person, size: 68, color: Colors.white),
              ),
              const SizedBox(height: 18),
              const Text(
                'George Moore',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Flutter Beginner & App Creator',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 18),
                  SizedBox(width: 6),
                  Text('Atlanta, GA, USA'),
                  SizedBox(width: 18),
                  Icon(Icons.email, color: Colors.red, size: 18),
                  SizedBox(width: 6),
                  Text('george@westga.edu'),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HobbiesScreen()),
                    ),
                    child: const Text(
                      'My hobbies',
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavoritePicsScreen()),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      'My favorite pics',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HobbiesScreen extends StatelessWidget {
  const HobbiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hobbies = [
      'Coding',
      'Playing Video Games',
      'Reading Philosophy Books',
      'Photography',
      'Watching Movies',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      drawer: const ProfileDrawer(),
      body: Center(
        child: Container(
          width: 360,
          height: 560,
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF3EA8E5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Builder(
                      builder: (ctx) => IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'My Hobbies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ListView.separated(
                    itemCount: hobbies.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFF9B7FE5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                hobbies[index],
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritePicsScreen extends StatelessWidget {
  const FavoritePicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pictures = [
      'Picture 1',
      'Picture 2',
      'Picture 3',
      'Picture 4',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      drawer: const ProfileDrawer(),
      body: Center(
        child: Container(
          width: 360,
          height: 560,
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF3EA8E5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Builder(
                      builder: (ctx) => IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Favorite Pics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: pictures.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.02,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF7FC9F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image, size: 52, color: Colors.white70),
                              const SizedBox(height: 8),
                              Text(
                                pictures[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF3EA8E5)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports_esports),
            title: const Text('My Hobbies'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HobbiesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Favorite Pics'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePicsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
