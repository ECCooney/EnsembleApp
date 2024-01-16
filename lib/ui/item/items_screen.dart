import 'package:flutter/material.dart';
import 'package:ensemble/app_localizations.dart';
import 'package:ensemble/models/item_model.dart';
import 'package:ensemble/models/user_model.dart';
import 'package:ensemble/providers/auth_provider.dart';
import 'package:ensemble/routes.dart';
import 'package:ensemble/services/firestore_database.dart';
import 'package:ensemble/ui/item/empty_content.dart';
import 'package:ensemble/ui/item/items_extra_actions.dart';
import 'package:provider/provider.dart';

import 'items_extra_actions.dart';

class ItemsScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase =
    Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel? user = snapshot.data as UserModel?;
              return Text(user != null
                  ? user.email! +
                  " - " +
                  AppLocalizations.of(context).translate("homeAppBarTitle")
                  : AppLocalizations.of(context).translate("homeAppBarTitle"));
            }),
        actions: <Widget>[
          StreamBuilder(
              stream: firestoreDatabase.itemsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ItemModel> items = snapshot.data as List<ItemModel>;
                  return Visibility(
                      visible: items.isNotEmpty ? true : false,
                      child: ItemsExtraActions());
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.setting);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.create_edit_item,
          );
        },
      ),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final firestoreDatabase =
    Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
        stream: firestoreDatabase.itemsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ItemModel> items = snapshot.data as List<ItemModel>;
            if (items.isNotEmpty) {
              return ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("itemsDismissibleMsgTxt"),
                            style: TextStyle(color: Theme.of(context).canvasColor),
                          )),
                    ),
                    key: Key(items[index].id),
                    onDismissed: (direction) {
                      firestoreDatabase.deleteItem(items[index]);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                        content: Text(
                          AppLocalizations.of(context)
                              .translate("itemsSnackBarContent") +
                              items[index].itemName,
                          style:
                          TextStyle(color: Theme.of(context).canvasColor),
                        ),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: AppLocalizations.of(context)
                              .translate("itemsSnackBarActionLbl"),
                          textColor: Theme.of(context).canvasColor,
                          onPressed: () {
                            firestoreDatabase.setItem(items[index]);
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                            ItemModel item = ItemModel(
                                id: items[index].id,
                                itemName: items[index].itemName,
                                description: items[index].description);
                            firestoreDatabase.setItem(item);
                          ),,
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.create_edit_item,
                            arguments: items[index]);
                      },
                    ),
                  , separatorBuilder: (BuildContext context, int index) {  },);
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 0.5);
                },
              );
            } else {
              return EmptyContentWidget(
                title: AppLocalizations.of(context)
                    .translate("itemsEmptyTopMsgDefaultTxt"),
                message: AppLocalizations.of(context)
                    .translate("itemsEmptyBottomDefaultMsgTxt"),
                key: Key('EmptyContentWidget'),
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContentWidget(
              title:
              AppLocalizations.of(context).translate("itemsErrorTopMsgTxt"),
              message: AppLocalizations.of(context)
                  .translate("itemsErrorBottomMsgTxt"),
              key: Key('EmptyContentWidget'),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}