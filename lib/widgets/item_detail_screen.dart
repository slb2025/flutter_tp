import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tp_widget/models/item.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({
    super.key,
    required this.item,
  });

  void _onTapEdit(BuildContext context) async {
    final Item? updatedItem = await context.push<Item?>(
      '/edit_contract',
      extra: item,
    );

    if (updatedItem != null) {
      context.pop(updatedItem);
    }
  }

  static _extractValue(String source, String key, [String defaultValue = 'Non renseigné']) {
    if (source.isEmpty) return defaultValue;
    final regex = RegExp('$key: (.+?)(\\s*\\||\$)');
    final match = regex.firstMatch(source);
    return match != null ? match.group(1)!.trim() : defaultValue;
  }

  static Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon, {bool isTitle = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0, top: isTitle ? 10.0 : 0),
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
                    fontWeight: isTitle ? FontWeight.w900 : FontWeight.bold,
                    color: isTitle ? Colors.black : Theme.of(context).primaryColor,
                    fontSize: isTitle ? 18 : 14,
                  ),
                ),
                if (!isTitle)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final numContrat = _extractValue(item.description, 'Contrat n°');
    final garantie = _extractValue(item.description, 'Garantie');
    final typeVehicule = _extractValue(item.detail ?? '', 'Type');
    final motorisation = _extractValue(item.detail ?? '', 'Moteur');
    final puissance = _extractValue(item.detail ?? '', 'Puissance');
    final usage = _extractValue(item.detail ?? '', 'Usage');
    final frequence = _extractValue(item.detail ?? '', 'Fréquence');
    final kilometrage = _extractValue(item.detail ?? '', 'Km/an');


    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _onTapEdit(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            _buildDetailRow(context, '1. Identification du Contrat', '', Icons.assignment, isTitle: true),

            _buildDetailRow(
              context,
              'Modèle du véhicule',
              item.name,
              Icons.directions_car,
            ),
            _buildDetailRow(
              context,
              'Plaque d\'immatriculation',
              item.immat,
              Icons.badge,
            ),
            _buildDetailRow(
              context,
              'Numéro de contrat',
              numContrat,
              Icons.receipt_long,
            ),
            _buildDetailRow(
              context,
              'Type de Garantie',
              garantie,
              Icons.shield,
            ),
            _buildDetailRow(
              context,
              'Date d\'effet',
              DateFormat('dd/MM/yyyy').format(item.effectiveDate),
              Icons.calendar_today,
            ),
            const Divider(),
            const SizedBox(height: 10),

            _buildDetailRow(context, '2. Caractéristiques techniques', '', Icons.settings, isTitle: true),

            _buildDetailRow(
              context,
              'Type de véhicule',
              typeVehicule,
              Icons.category,
            ),
            _buildDetailRow(
              context,
              'Motorisation',
              motorisation,
              Icons.local_gas_station,
            ),
            _buildDetailRow(
              context,
              'Puissance fiscale',
              puissance,
              Icons.flash_on,
            ),
            const Divider(),
            const SizedBox(height: 10),

            _buildDetailRow(context, '3. Données d\'usage', '', Icons.people, isTitle: true),

            _buildDetailRow(
              context,
              'Usage du véhicule',
              usage,
              Icons.work,
            ),
            _buildDetailRow(
              context,
              'Fréquence d\'utilisation',
              frequence,
              Icons.access_time,
            ),
            _buildDetailRow(
              context,
              'Kilométrage annuel estimé',
              kilometrage,
              Icons.speed,
            ),
          ],
        ),
      ),
    );
  }
}