import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '/Providers/UserProvider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
    State<UsersPage> createState() => _UsersState();
}

class _UsersState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('USERS')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.cyan),
                  title: Text(user.name),
                  subtitle: Text(user.username),
                  trailing: Text(user.website),
                );
              },
            ),
    );
  }
}