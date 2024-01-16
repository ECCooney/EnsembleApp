import 'package:flutter/material.dart';
import 'package:ensemble/app_localizations.dart';
import 'package:ensemble/services/firestore_database.dart';
import 'package:provider/provider.dart';

enum ItemsActions { toggleAllComplete, clearCompleted }

class ItemsExtraActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirestoreDatabase firestoreDatabase = Provider.of(context);

    return PopupMenuButton<ItemsActions>(
      icon: Icon(Icons.more_horiz),
      onSelected: (ItemsActions result) {
        switch (result) {
          case ItemsActions.toggleAllComplete:
            firestoreDatabase.setAllItemComplete();
            break;
          case ItemsActions.clearCompleted:
            firestoreDatabase.deleteAllItemWithComplete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ItemsActions>>[
        PopupMenuItem<ItemsActions>(
          value: ItemsActions.toggleAllComplete,
          child: Text(AppLocalizations.of(context)
              .translate("itemsPopUpToggleAllComplete")),
        ),
        PopupMenuItem<ItemsActions>(
          value: ItemsActions.clearCompleted,
          child: Text(AppLocalizations.of(context)
              .translate("itemsPopUpToggleClearCompleted")),
        ),
      ],
    );
  }
}