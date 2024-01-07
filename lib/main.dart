import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Zakupów',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingList(),
    );
  }
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<Map<String, dynamic>> products = [
    {'name': 'Mleko', 'quantity': '1 litr', 'purchased': false},
    {'name': 'Chleb', 'quantity': '2 bochenki', 'purchased': false},
    {'name': 'Jajka', 'quantity': '10 sztuk', 'purchased': true},
    {'name': 'Jabłka', 'quantity': '5 sztuk', 'purchased': true},
    {'name': 'Makaron', 'quantity': '3 opakowania', 'purchased': false},
    {'name': 'Pomidor', 'quantity': '4 sztuki', 'purchased': false},
    {'name': 'Cebula', 'quantity': '3 sztuki', 'purchased': false},
    {'name': 'Oliwa z oliwek', 'quantity': '0.5 litra', 'purchased': true},
    {'name': 'Papryka', 'quantity': '2 sztuki', 'purchased': false},
    {'name': 'Ser', 'quantity': '200 gramów', 'purchased': true},
    {'name': 'Kawa', 'quantity': '250 gramów', 'purchased': false},
    {'name': 'Herbata', 'quantity': '50 torebek', 'purchased': false},
    {'name': 'Cukier', 'quantity': '1 kilogram', 'purchased': true},
    {'name': 'Mąka', 'quantity': '500 gramów', 'purchased': false},
    {'name': 'Ryż', 'quantity': '1 kilogram', 'purchased': false},
    {'name': 'Owoce leśne', 'quantity': '300 gramów', 'purchased': true},
    {'name': 'Chipsy', 'quantity': '2 opakowania', 'purchased': false},
    {'name': 'Piwo', 'quantity': '6 butelek', 'purchased': true},
    {'name': 'Szynka', 'quantity': '150 gramów', 'purchased': false},
  ];

  late List<Map<String, dynamic>> originalProducts;

  TextEditingController productController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    originalProducts = List.from(products);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? lastRemovedItem;
  bool isDarkMode = false;

  void addProduct() async {
    productController.clear();
    quantityController.clear();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dodaj nowy produkt',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: productController,
                  decoration: InputDecoration(labelText: 'Nazwa produktu'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Ilość'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Anuluj'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          String newProduct = productController.text;
                          String newQuantity = quantityController.text;

                          if (newProduct.isNotEmpty && newQuantity.isNotEmpty) {
                            products.add({
                              'name': newProduct,
                              'quantity': newQuantity,
                              'purchased': false
                            });
                            originalProducts.add({
                            'name': newProduct,
                            'quantity': newQuantity,
                            'purchased': false
                            });
                          }
                        });
                      },
                      child: Text('Dodaj'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editProduct(int index) async {
    TextEditingController editProductController = TextEditingController(
        text: products[index]['name']);
    TextEditingController editQuantityController = TextEditingController(
        text: products[index]['quantity']);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edytuj produkt',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: editProductController,
                  decoration: InputDecoration(labelText: 'Nazwa produktu'),
                ),
                TextField(
                  controller: editQuantityController,
                  decoration: InputDecoration(labelText: 'Ilość'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Anuluj'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          products[index]['name'] = editProductController.text;
                          products[index]['quantity'] =
                              editQuantityController.text;
                        });
                      },
                      child: Text('Zapisz'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeProduct(int index) {
    lastRemovedItem = products[index];

    setState(() {
      products.removeAt(index);
    });

    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text('Produkt ${lastRemovedItem?["name"]} został usunięty.'),
        action: SnackBarAction(
          label: 'Cofnij',
          onPressed: () {
            setState(() {
              products.insert(index, lastRemovedItem!);
            });

            lastRemovedItem = null;
          },
        ),
      ),
    );
  }

  void resetList() {
    setState(() {
      products.clear();
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void searchProduct(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, show all products
        products = List.from(originalProducts);
      } else {
        // Otherwise, filter products based on the query
        products = originalProducts.where((product) {
          return product['name']
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    products.sort((a, b) {
      if (a['purchased'] == b['purchased']) {
        return 0;
      }
      return a['purchased'] ? 1 : -1;
    });

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Lista zakupów'),
        ),
        body: Column(
          children: [
            // Pole wyszukiwania
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: searchProduct,
                decoration: InputDecoration(
                  labelText: 'Wyszukaj produkt',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? Center(
                child: Text(
                  'Lista zakupów jest pusta.',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
                  : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  bool isFirstItem = index == 0;
                  bool isStatusChanged = index > 0 &&
                      products[index]['purchased'] !=
                          products[index - 1]['purchased'];

                  return Column(
                    children: [
                      if (!isFirstItem && isStatusChanged) Divider(),
                      Dismissible(
                        key: Key(products[index]['name']),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            removeProduct(index);
                          }
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${products[index]['name']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: products[index]
                                      ['purchased']
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    '${products[index]['quantity']}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      decoration: products[index]
                                      ['purchased']
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => editProduct(index),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        products[index]['purchased']
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          products[index]['purchased'] =
                                          !products[index]['purchased'];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addProduct,
          tooltip: 'Dodaj produkt',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  tooltip: isDarkMode
                      ? "Zmień na tryb jasny"
                      : "Zmień na tryb ciemny",
                  onPressed: toggleTheme,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.refresh),
                  tooltip: "Resetuj listę",
                  onPressed: resetList,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}