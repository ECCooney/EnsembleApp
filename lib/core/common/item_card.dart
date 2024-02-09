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

  void navigateToEditItem(BuildContext context) {
    Routemaster.of(context).push('/edit-item/${item.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        // boundary needed for web
        decoration: BoxDecoration(
          border: Border.all(
            color: Pallete.sageCustomColor,
          ),
          color: Pallete.whiteColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(user.profilePic,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (item.owner == user.uid)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map(
                                      (e) => InkWell(
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16),
                                        child: Text(e),
                                      ),
                                      onTap: () {
                                        deleteItem(ref, context,);
                                        // remove the dialog box
                                        Navigator.of(context).pop();
                                      }),
                                )
                                    .toList()),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            // IMAGE SECTION OF THE POST
            GestureDetector(
              onDoubleTap: () {navigateToItem(context);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(item.itemPic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.open_in_new,
                    ),
                    onPressed: () {navigateToItem(context);}),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: const Icon(Icons.edit), onPressed: () {navigateToEditItem(context);}),
                    ))
              ],
            ),
            //DESCRIPTION
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Pallete.blackColor),
                        children: [
                          TextSpan(
                            text:item.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${item.description}',
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

