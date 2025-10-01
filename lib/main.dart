import 'package:flutter/material.dart';
import 'package:tp_widget/models/item.dart';
import 'package:tp_widget/widgets/contribution_page.dart';
import 'package:tp_widget/widgets/item_card.dart';
import 'package:tp_widget/widgets/new_contract_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLB Assur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

@override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Item> _contracts = Item.items;

  // Variable d'état pour la BottomNavigationBar
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _addNewContract(Item newContract) {
    setState(() {
      _contracts.add(newContract);
      // Optionnel : s'assurer que l'onglet 'Mes assurances' est sélectionné
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetOptions = <Widget>[
      ItemListContent(
        items: _contracts,
        onAddContract: _addNewContract,
      ),
      const ContributionPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,

        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon (
              Icons.directions_car,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              "Mes véhicules assurés",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
            },
          ),
        ],
      ),

      body: widgetOptions.elementAt(_selectedIndex),

      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                // Utiliser 'await' pour attendre le résultat (le nouvel Item)
                final Item? newContract = await Navigator.of(context).push(
                  MaterialPageRoute<Item>(
                    builder: (context) => const NewContractScreen(),
                  ),
                );
                // Vérifier si un Item a été renvoyé (si l'utilisateur n'a pas juste fait retour)
                if (newContract != null) {
                  _addNewContract(newContract); // Utiliser la fonction pour mettre à jour l'état
                }
              },
              child: const Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue[300],
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Mes assurances',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Contribuer',
          ),
        ],
      ),
    );
  }
}

// Widget séparé pour le contenu de la liste des items
class ItemListContent extends StatelessWidget {
  final List<Item> items;
  final Function(Item) onAddContract;

  const ItemListContent({
    super.key,
    required this.items,
    required this.onAddContract,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemCard(item: items[index]);
        }
    );
  }
}