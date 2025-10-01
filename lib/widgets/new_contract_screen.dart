import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({super.key});

  @override
  State<NewContractScreen> createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  // 1. Contrôleurs pour récupérer les valeurs des champs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  // Pour l'imageAsset, on simule une valeur par défaut ou une saisie future
  final String _defaultImage = 'assets/peugeot_308.webp';

  // Clé pour valider le formulaire (optionnel pour ce TP mais bonne pratique)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Il est crucial de disposer des contrôleurs pour éviter les fuites de mémoire
    _nameController.dispose();
    _descriptionController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _saveContract(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final newItem = Item(
        name: _nameController.text,
        description: _descriptionController.text,
        detail: _detailController.text,
        imageAsset: _defaultImage,
      );
      // Fermer l'écran du formulaire
      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Nouveau Contrat"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Champ 'Name' (Nom du Véhicule)
              _buildTextField(
                  _nameController, "Nom du Véhicule", Icons.directions_car),
              const SizedBox(height: 15),

              // Champ 'Description' (Numéro de Contrat)
              _buildTextField(
                  _descriptionController, "Numéro et Date du Contrat",
                  Icons.description, maxLines: 2),
              const SizedBox(height: 15),

              // Champ 'Detail' (Garantie)
              _buildTextField(
                  _detailController, "Type de Garantie", Icons.shield),
              const SizedBox(height: 30),

              // Bouton d'enregistrement
              ElevatedButton(
                onPressed: () => _saveContract(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Enregistrer le Contrat',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget utilitaire pour simplifier la construction des champs
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      // Validation simple pour s'assurer que le champ n'est pas vide
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire.';
        }
        return null;
      },
    );
  }
}