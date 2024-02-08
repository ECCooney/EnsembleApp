import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ItemScreen extends ConsumerWidget {

  final String id;
  const ItemScreen({
    required this.id,
    super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title:const Text('Item Details'),)
    );
  }
}
