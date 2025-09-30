import 'package:flutter/material.dart';

class Item {

  final String name;
  final String description;

  Item ({
    required this.name,
    required this.description,
});

  static List<Item> items = [
    Item(
        name:'Projet Manhattan',
        description:'un projet vraiment énorme'
    ),
    Item(
        name:'Projet Manhattan',
        description:'un projet vraiment énorme'
    ),
  ];
}

