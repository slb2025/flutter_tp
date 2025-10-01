class Item {

  final String name;
  final String description;
  final String? detail;
  final String imageAsset;

  Item ({
    required this.name,
    required this.description,
    required this.detail,
    required this.imageAsset,
});

  static List<Item> items = [
    Item(
      // Nom : Le véhicule assuré
      name: 'Peugeot 308 (AB-123-CD)',
      // Description : Le numéro de contrat (l'info la plus longue)
      description: 'Contrat n° A123456789 - Prise d\'effet : 01/01/2024',
      // Detail : Le niveau de garantie pour le titre de la carte
      detail: 'Garantie Tous Risques',
      imageAsset: 'assets/peugeot_308.webp',
    ),
    Item(
      name: 'Renault Clio V (EF-456-GH)',
      description: 'Contrat n° B987654321 - Prise d\'effet : 15/05/2023',
      detail: 'Garantie Tiers Vol-Incendie',
      imageAsset: 'assets/renault_clioV.webp',
    ),
    Item(
      name: 'Moto Yamaha MT-07 (IJ-789-KL)',
      description: 'Contrat n° C112233445 - Prise d\'effet : 01/03/2024',
      detail: 'Garantie Tiers Simple',
      imageAsset: 'assets/yamaha_mt07.webp',
    ),
  ];
}

