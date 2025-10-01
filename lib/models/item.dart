// --- Définition de la classe de modèle 'Item' ---
class Item {

  // --- Propriétés (champs) de l'objet Item ---
  final String name;
  final String description;
  final String? detail; // Peut être null (optionnel)
  final String imageAsset;
  final DateTime effectiveDate;

  // --- Constructeur de la classe Item ---
  Item ({
    required this.name,
    required this.description,
    this.detail, // Le mot-clé 'required' n'est pas utilisé, car il est optionnel (String?)
    required this.imageAsset,
    required this.effectiveDate,
  });

  // --- Liste statique des items par défaut (données initiales) ---
  static List<Item> items = [
    Item(
      // Nom : Le véhicule assuré et son immatriculation
      name: 'Peugeot 308 (AB-123-CD)',
      // Description : Le numéro de contrat (l'info la plus importante/longue)
      description: 'Contrat n° A123456789',
      // Detail : Le niveau de garantie pour le sous-titre de la carte
      detail: 'Garantie Tous Risques',
      imageAsset: 'assets/peugeot_308.webp',
      effectiveDate: DateTime(2024, 1, 1),
    ),
    Item(
      name: 'Renault Clio V (EF-456-GH)',
      description: 'Contrat n° B987654321',
      detail: 'Garantie Tiers Vol-Incendie',
      imageAsset: 'assets/renault_clioV.webp',
      effectiveDate: DateTime(2023, 5, 15),
    ),
    Item(
      name: 'Moto Yamaha MT-07 (IJ-789-KL)',
      description: 'Contrat n° C112233445 - Prise d\'effet : 01/03/2024',
      detail: 'Garantie Tiers Simple',
      imageAsset: 'assets/yamaha_mt07.webp',
      effectiveDate: DateTime(2024, 3, 1),
    ),
  ];
}