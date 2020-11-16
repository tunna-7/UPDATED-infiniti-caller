import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:phonebook/models/contact.dart';
import '../utilities/image_conversion.dart';
import '../utilities/DatabaseHelper.dart';

class EditContactScreen extends StatefulWidget {
  static final String routeName = '/edit-contact';
  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _name, _lastName, _cellNumber, _stringImage, _email, _gender;
  bool _favorite = true;
  // DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final Contact contact = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Contact',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () {
              _submit(contact);
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
        child: SingleChildScrollView(
          child: _buildContactForm(contact),
        ),
      ),
    );
  }

  Form _buildContactForm(Contact contact) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row for contact image and name fields
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _handleImage();
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        image: DecorationImage(
                          image: (contact.image != null &&
                                  contact.image.isNotEmpty)
                              ? _image != null
                                  ? FileImage(_image)
                                  : MemoryImage(
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
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 200.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: contact.firstName,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                                top: 14.0, right: 8.0, left: 8.0),
                            hintText: 'Enter first name',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          validator: (input) =>
                              input.isEmpty ? 'Name is required' : null,
                          onSaved: (input) => _name = input,
                        ),
                      ),
                      Container(
                        width: 200.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: contact.lastName,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                                top: 14.0, right: 8.0, left: 8.0),
                            hintText: 'Enter last name',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          onSaved: (input) => _lastName = input,
                        ),
                      ),
                      Container(
                        width: 200.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: contact.cellularNum.toString(),
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                                top: 14.0, right: 8.0, left: 8.0),
                            hintText: 'Enter number',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          validator: (input) => input.length < 10
                              ? 'Cell number must be 10 digits'
                              : null,
                          onSaved: (input) => _cellNumber = input,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 12.0, left: 12.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: contact.email.toString(),
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 14.0, right: 8.0, left: 8.0),
                        hintText: 'Enter email',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      onSaved: (input) => _email = input,
                    ),
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 1.0,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 12.0, left: 12.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 200.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: contact.gender.toString(),
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 14.0, right: 8.0, left: 8.0),
                        hintText: 'Enter Gender',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      onSaved: (input) => _gender = input,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            child: FlatButton(
              child: Text(
                'Add more info',
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  _handleImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      _stringImage = ImageConversion.base64String(imageFile.readAsBytesSync());
      setState(() {
        _image = imageFile;
      });
    }
  }

  _submit(Contact oldContact) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_name.isNotEmpty && _cellNumber.isNotEmpty) {
        Contact contact = Contact(
          id: oldContact.id,
          firstName: _name,
          lastName: _lastName,
          image: _image == null ? oldContact.image : _stringImage,
          cellularNum: int.parse(_cellNumber),
          homeNum: int.parse('0'),
          workplaceNum: int.parse('0'),
          email: _email,
          gender: _gender,
          birthdate: '',
          favorite: _favorite,
        );
        var result = await DatabaseHelper().editContact(contact);
        if (result != -1) {
          Navigator.of(context).pop(contact);
        }
      }
    }
  }
}
