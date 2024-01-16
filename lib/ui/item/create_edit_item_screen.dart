import 'package:flutter/material.dart';
import 'package:ensemble/app_localizations.dart';
import 'package:ensemble/models/item_model.dart';
import 'package:ensemble/services/firestore_database.dart';
import 'package:provider/provider.dart';

class CreateEditItemScreen extends StatefulWidget {
  @override
  _CreateEditItemScreenState createState() => _CreateEditItemScreenState();
}

class _CreateEditItemScreenState extends State<CreateEditItemScreen> {
  late TextEditingController _itemController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ItemModel? _item;
  late bool _checkboxCompleted;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ItemModel? _itemModel = ModalRoute.of(context)?.settings.arguments as ItemModel?;
    if (_itemModel != null) {
      _item = _itemModel;
    }

    _itemController =
        TextEditingController(text: _item?.itemName ?? "");
    _descriptionController =
        TextEditingController(text: _item?.description ?? "");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_item != null
            ? AppLocalizations.of(context)
            .translate("itemsCreateEditAppBarTitleEditTxt")
            : AppLocalizations.of(context)
            .translate("itemsCreateEditAppBarTitleNewTxt")),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();

                  final firestoreDatabase =
                  Provider.of<FirestoreDatabase>(context, listen: false);

                  firestoreDatabase.setItem(ItemModel(
                      id: _item?.id ?? documentIdFromCurrentDate(),
                      itemName: _itemController.text,
                      description: _descriptionController.text.length > 0
                          ? _descriptionController.text
                          : ""));

                  Navigator.of(context).pop();
                }
              },
              child: Text("Save"))
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _itemController,
                style: Theme.of(context).textTheme.bodyLarge,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)
                    .translate("itemsCreateEditTaskNameValidatorMsg")
                    : null,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color!, width: 2)),
                  labelText: AppLocalizations.of(context)
                      .translate("itemsCreateEditTaskNameTxt"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextFormField(
                  controller: _descriptionController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 15,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).iconTheme.color!,
                            width: 2)),
                    labelText: AppLocalizations.of(context)
                        .translate("itemsCreateEditNotesTxt"),
                    alignLabelWithHint: true,
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)
                        .translate("itemsCreateEditCompletedTxt")),
                    Checkbox(
                        value: _checkboxCompleted,
                        onChanged: (value) {
                          setState(() {
                            _checkboxCompleted = value!;
                          });
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}