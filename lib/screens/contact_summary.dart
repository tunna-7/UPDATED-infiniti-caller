import 'package:flutter/material.dart';

import '../screens/edit_contact_screen.dart';
import '../models/contact.dart';
import '../utilities/image_conversion.dart';
import '../utilities/DatabaseHelper.dart';

class ContactSummary extends StatefulWidget {
  static final String routeName = '/contact-summary';

  @override
  _ContactSummaryState createState() => _ContactSummaryState();
}

class _ContactSummaryState extends State<ContactSummary> {
  @override
  Widget build(BuildContext context) {
    Contact contact;
    contact = ModalRoute.of(context).settings.arguments;

    _updateInfoAfterEdit() async {
      final result = await Navigator.of(context)
          .pushNamed(EditContactScreen.routeName, arguments: contact);

      setState(() {
        contact = result;
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite_border,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.mode_edit,
            ),
            onPressed: () {
              _updateInfoAfterEdit();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              width: 170,
              margin: const EdgeInsets.only(top: 40.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                image: DecorationImage(
                  image: contact.image != null && contact.image.isNotEmpty
                      ? MemoryImage(
                          ImageConversion.dataFromBase64String(
                            contact.image,
                          ),
                        )
                      : AssetImage(
                          'assets/images/user_profile_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '${contact.firstName} ${contact.lastName}',
              style: TextStyle(fontSize: 18.0),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        'Cellular Phone',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Text(contact.cellularNum.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.phone),
                          SizedBox(
                            width: 15.0,
                          ),
                          Icon(Icons.message),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text(
                          'Email',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        subtitle: Text(contact.email.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.message),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: const Text(
                          'Gender',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        subtitle: Text(contact.gender.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.wc),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              child: Text(
                'Delete Contact',
                style: TextStyle(
                    color: Theme.of(context).errorColor, fontSize: 16.0),
              ),
              onPressed: () {
                _deleteContact(contact.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteContact(String id) async {
    var result = await DatabaseHelper().deleteContact(id);
    if (result != -1) {
      Navigator.of(context).pop(id);
    }
  }
}
