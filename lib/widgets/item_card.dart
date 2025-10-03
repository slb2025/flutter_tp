import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';

import 'item_detail_screen.dart';

// --- Définition de la classe du widget ---
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

  // --- Méthode utilitaire pour construire l'image d'en-tête ---
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
  // --- Méthode de construction du widget ---
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          // --- Affichage de l'image (leading) ---
          leading: _buildLeadingImage(),

          // --- Bouton de suppression (trailing) ---
          trailing: IconButton(
            onPressed: onTapDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),

          // --- Titre ---
          title: Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          // --- Sous-titre (description et garantie) ---
          subtitle: Text(
            '${item.description} | Garantie: ${item.detail ?? 'Non spécifiée'}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // --- Action au clic sur la carte ---
          onTap: onTapDetail,
        ),
      ),
    );
  }
}