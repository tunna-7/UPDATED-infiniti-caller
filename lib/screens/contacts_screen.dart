import 'package:flutter/material.dart';

import './add_contact.dart';
import '../utilities/DatabaseHelper.dart';
import '../utilities/image_conversion.dart';
import '../models/contact.dart';
import './contact_summary.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, dynamic>> contactList = [];

  @override
  void initState() {
    super.initState();

    _setContactList();
  }

  void _setContactList() async {
    var list = await DatabaseHelper().getContactsList();
    setState(() {
      contactList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        centerTitle: true,
        leading: Container(
          height: 20,
          width: 20,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/user_profile_placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.group,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddContactScreen.routeName),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    top: 14.0,
                    right: 8.0,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: 'Search in 288 contacts',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).accentColor,
                ),
                child: contactList.length < 0
                    ? Center(
                        child: Text(
                          'No contacts yet. Click + icon to add contacts',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemCount: contactList.length,
                        itemBuilder: (ctx, i) =>
                            _buildListTileContact(contactList[i]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildListTileContact(Map<String, dynamic> map) {
    Contact contact = Contact.fromMap(map);
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ContactSummary.routeName, arguments: contact),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 100,
              child: CircleAvatar(
                backgroundImage: contact.image != null
                    ? MemoryImage(
                        ImageConversion.dataFromBase64String(
                          contact.image,
                        ),
                      )
                    : AssetImage('assets/images/user_profile_placeholder.png'),
              ),
            ),
            title: Text(
              '${contact.firstName} ${contact.lastName}',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(contact.cellularNum.toString()),
            trailing: IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            thickness: 2.0,
            color: Theme.of(context).buttonColor,
          ),
        ),
      ],
    );
  }
}
