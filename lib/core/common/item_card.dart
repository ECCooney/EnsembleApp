import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/item/controller/item_controller.dart';
import '../../models/item_model.dart';

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
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Hero(
                transitionOnUserGestures: true,
                tag: item.id!,
                child: Image.network(
                  item.itemPic!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(item.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
               Text(item.description,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(),
              ),
              IconButton(
                  icon: const Icon(Icons.open_in_new),
                  color: Colors.black,
                  iconSize: 25,
                  onPressed: () {navigateToItem(context);
                  }),
            ],
          )
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider)!;
//     final width = MediaQuery.of(context).size.width;
//
//     return Flexible(
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Container(
//           // boundary needed for web
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Pallete.sageCustomColor,
//             ),
//             color: Pallete.whiteColor,
//           ),
//           padding: const EdgeInsets.symmetric(
//             vertical: 10,
//           ),
//           child: Column(
//             children: [
//               // header section
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 4,
//                   horizontal: 16,
//                 ).copyWith(right: 0),
//                 child: Row(
//                   children: <Widget>[
//                     CircleAvatar(
//                       radius: 16,
//                       backgroundImage: NetworkImage(
//                         user.profilePic,
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 8,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               item.name,
//                               style: const TextStyle(
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (item.owner == user.uid)
//                       IconButton(
//                         onPressed: () {
//                           showDialog(
//                             useRootNavigator: false,
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 child: ListView(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 16),
//                                   shrinkWrap: true,
//                                   children: [
//                                     'Delete',
//                                   ]
//                                       .map(
//                                         (e) => InkWell(
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 12, horizontal: 16),
//                                         child: Text(e),
//                                       ),
//                                       onTap: () {
//                                         deleteItem(ref, context);
//                                         // remove the dialog box
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                   )
//                                       .toList(),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(Icons.more_vert),
//                       ),
//                   ],
//                 ),
//               ),
//               // IMAGE SECTION OF THE POST
//               GestureDetector(
//                 onDoubleTap: () {
//                   navigateToItem(context);
//                 },
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.35,
//                       width: double.infinity,
//                       child: Image.network(
//                         item.itemPic,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: <Widget>[
//                   IconButton(
//                       icon: const Icon(
//                         Icons.open_in_new,
//                       ),
//                       onPressed: () {
//                         navigateToItem(context);
//                       }),
//                   Expanded(
//                       child: Align(
//                         alignment: Alignment.bottomRight,
//                         child: IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () {
//                               navigateToEditItem(context);
//                             }),
//                       ))
//                 ],
//               ),
//               //DESCRIPTION
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 item.description,
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                           FutureBuilder<List<DateTime>>(
//                             future: ref.read(getBookedDatesProvider(item.id).future),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Loader();
//                               } else if (snapshot.hasError) {
//                                 return ErrorText(error: snapshot.error.toString());
//                               } else {
//                                 final today = DateTime.now();
//                                 final bookedDates = snapshot.data!;
//                                 final isBookedToday =
//                                 bookedDates.contains(DateTime(
//                                     today.year, today.month, today.day));
//                                 return Row(
//                                   children: [
//                                     Text(
//                                       isBookedToday
//                                           ? 'Check Availability'
//                                           : 'Available Today',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w300,
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }