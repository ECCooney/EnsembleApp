import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../group/controller/group_controller.dart';

//https://api.flutter.dev/flutter/material/SearchDelegate-class.html

class SearchGroupDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchGroupDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchGroupProvider(query)).when(
      data: (groups) => ListView.builder(
        itemCount: groups.length,
        itemBuilder: (BuildContext context, int index) {
          final group = groups[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(group.groupPic),
            ),
            title: Text(group.name),
            onTap: () => navigateToGroup(context, group.id),
          );
        },
      ),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
      loading: () => const Loader(),
    );
  }

  void navigateToGroup(BuildContext context, String id) {
    Routemaster.of(context).push(id);
  }
}