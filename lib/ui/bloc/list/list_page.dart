import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  @override
  void initState() {
    context.read<ListBloc>().add(ListLoadEvent());
    super.initState();
  }

  void _logout() {
    GetIt.I<SharedPreferences>().remove('token');
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<ListBloc, ListState>(
            listenWhen: (_, state) => state is ListError,
            listener: (context, state) {
              if (state is ListError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            buildWhen: (_, state) => state is! ListError,
            builder: (context, state) {
              if (state is ListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ListLoaded) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final item = state.users[index];
                    return ListTile(
                      title: Text(item.name),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Unknown state'));
              }
            },
          ),
        )
    );
  }
}
