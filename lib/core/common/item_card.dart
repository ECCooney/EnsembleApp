import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../features/auth/controller/auth_controller.dart';
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onDoubleTap: () {
                    navigateToItem(context);
                  },
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: item.id!,
                    child: Image.network(
                      item.itemPic!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                    ),
                  ),
                ),
              ),
              if (item.owner == user.uid)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                                    navigateToEditItem(context);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              if (item.owner != user.uid)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    color: Colors.black,
                    iconSize: 25,
                    onPressed: () {
                      navigateToItem(context);
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20, // Adjust the font size as per your requirement
              ),
            ),
          ),
          FutureBuilder<List<DateTime>>(
            future: ref.read(getBookedDatesProvider(item.id!).future),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loader();
              } else if (snapshot.hasError) {
                return ErrorText(error: snapshot.error.toString());
              } else {
                final today = DateTime.now();
                final bookedDates = snapshot.data!;
                final isBookedToday = bookedDates.contains(
                  DateTime(today.year, today.month, today.day),
                );
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          navigateToItem(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            isBookedToday ? Colors.white : Colors.white, // Set button color based on availability
                          ),
                        ),
                        child: Text(
                          isBookedToday ? 'Check Availability' : 'Available Today',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}