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

    printFav();
  }

  void printFav() async {
    var favorite = await DatabaseHelper().getFavorites();
    print(favorite.toString());
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
            onPressed: () {
              printFav();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              _updateAddedListOfContacts();
            },
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
                onChanged: (value) async {
                  try {
                    var result = await DatabaseHelper().searchContact(value);
                    setState(() {
                      contactList = result;
                    });
                  } catch (e) {}
                },
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
                  hintText: 'Search in ${contactList.length} contacts',
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
                child: contactList.length <= 0
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
          onTap: () {
            _updateDeletedListOfContacts(contact);
          },
          child: ListTile(
            leading: Container(
              width: 60,
              height: 100,
              child: CircleAvatar(
                backgroundImage: contact.image != null &&
                        contact.image.isNotEmpty
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
              icon: Icon(
                  contact.favorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () async {
                Contact newContact = Contact(
                  id: contact.id,
                  firstName: contact.firstName,
                  lastName: contact.lastName,
                  image: contact.image,
                  cellularNum: contact.cellularNum,
                  homeNum: int.parse('0'),
                  workplaceNum: int.parse('0'),
                  email: '',
                  birthdate: '',
                  favorite: !contact.favorite,
                );
                await DatabaseHelper().editContact(newContact);
                _setContactList();
              },
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

  _updateDeletedListOfContacts(Contact contact) async {
    await Navigator.of(context)
        .pushNamed(ContactSummary.routeName, arguments: contact);

    _setContactList();
  }

  _updateAddedListOfContacts() async {
    await Navigator.of(context).pushNamed(AddContactScreen.routeName);

    _setContactList();
  }
}
