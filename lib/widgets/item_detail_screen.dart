import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image (Réutilisation du style d'ItemCard) ---
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    item.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red, size: 100);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- Informations de base ---
            _buildDetailRow(
              context,
              'Nom/Immatriculation',
              item.name,
              Icons.directions_car,
            ),
            _buildDetailRow(
              context,
              'Description du contrat',
              item.description,
              Icons.description,
            ),
            _buildDetailRow(
              context,
              'Détail des usages',
              item.detail ?? 'Non spécifié',
              Icons.info_outline,
            ),
            _buildDetailRow(
              context,
              'Date d\'effet',
              '${item.effectiveDate.day.toString().padLeft(2, '0')}/${item.effectiveDate.month.toString().padLeft(2, '0')}/${item.effectiveDate.year}',
              Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour afficher les lignes de détail
  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}