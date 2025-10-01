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

  // Variable d'état pour la BottomNavigationBar
  int _selectedIndex = 0;

  // Liste des widgets à afficher en fonction de _selectedIndex
  late final List<Widget> _widgetOptions;


  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const ItemListContent(),   // Le contenu de votre liste de contrats
      const ContributionPage(),  // La page de contribution
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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

      body: _widgetOptions.elementAt(_selectedIndex),

      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewContractScreen(),
                  ),
                );
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
  const ItemListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Item> items = Item.items;
    return ListView.builder(
        itemCount: items.length,
        // Supprimez le padding: const EdgeInsets.all(100) qui décalait la liste
        itemBuilder: (context, index) {
          return ItemCard(item: items[index]);
        }
    );
  }
}