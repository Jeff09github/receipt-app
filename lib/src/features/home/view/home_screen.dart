import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../profiles_overview/profiles_overview.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPPOE Customer List'),
        centerTitle: true,
      ),
      body: const ProfilesOverviewPage(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add_alt_rounded),
        onPressed: () {
          GoRouter.of(context).push('/create-profile');
        },
      ),
    );
  }
}
