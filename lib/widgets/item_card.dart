import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';

import 'item_detail_screen.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapDetail;


  const ItemCard({
    super.key,
    required this.item,
    this.onTapDelete,
    this.onTapDetail,
  });

  Widget _buildLeadingImage() {
    return SizedBox(
      width: 50,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          item.imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red);
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          leading: _buildLeadingImage(),

          trailing: IconButton(
            onPressed: onTapDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),

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

          onTap: onTapDetail,
        ),
      ),
    );
  }
}