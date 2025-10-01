import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    item.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              ),

              trailing: const Icon(Icons.chevron_right),

              title: Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              subtitle: Text(
                '${item.description} | Garantie: ${item.detail ?? 'Non spécifiée'}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              onTap: () {
                print('Ouverture du contrat ${item.name}');
              },
            ),
          ],
        ),
      ),
    );
  }
}