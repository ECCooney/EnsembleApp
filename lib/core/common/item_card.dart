import 'package:ensemble/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../features/group/controller/group_controller.dart';
import '../../features/item/controller/item_controller.dart';
import '../../models/item_model.dart';
import 'error_text.dart';
import 'loader.dart';

class ItemCard extends ConsumerWidget {
  final ItemModel item;

  const ItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  void deleteItem(WidgetRef ref, BuildContext context) async {
    ref.read(itemControllerProvider.notifier).deleteItem(item, context);
  }


  void navigateToItem(BuildContext context) {
    Routemaster.of(context).push('/item/${item.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              navigateToItem(context);
            },
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                   child: Image.network(
                        item.itemPic,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
        
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                IconButton(
                  alignment: Alignment.bottomLeft,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
              ],
            ),
          ),
        ),
    );
  }
}

