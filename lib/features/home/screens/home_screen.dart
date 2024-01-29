import 'package:ensemble/features/auth/controller/auth_controller.dart';
import 'package:ensemble/features/nav/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
     appBar:AppBar(
       title:const Text('Home'),
       centerTitle: false,
       leading: IconButton(
         icon: const Icon(Icons.menu),
         onPressed: (){
           NavDrawer();
           },
       ),
       actions: [
         IconButton(onPressed: (){}, icon: const Icon(Icons.search),),
         IconButton(
         icon: CircleAvatar(
           backgroundImage: NetworkImage(user!.profilePic),
         ),
         onPressed:(){},
         ),
       ]
     ),
      drawer: const NavDrawer(),
    );
  }
}
