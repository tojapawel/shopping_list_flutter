// shopping_list.dart
import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<Map<String, dynamic>> products = [];

  TextEditingController productController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  void addProduct() {
    setState(() {
      String newProduct = productController.text;
      String newQuantity = quantityController.text;

      if (newProduct.isNotEmpty && newQuantity.isNotEmpty) {
        products.add({'name': newProduct, 'quantity': newQuantity, 'purchased': false});
        productController.clear();
        quantityController.clear();
      }
    });
  }

  void editProduct(int index) async {
    TextEditingController editProductController = TextEditingController(text: products[index]['name']);
    TextEditingController editQuantityController = TextEditingController(text: products[index]['quantity']);

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
                        setState(() {
                          products[index]['name'] = editProductController.text;
                          products[index]['quantity'] = editQuantityController.text;
                        });
                        Navigator.of(context).pop();
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
    setState(() {
      products.removeAt(index);
    });
  }

  void resetList() {
    setState(() {
      products.clear();
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

    // Sort by insertion order for unchecked items
    int uncheckedIndex = products.indexWhere((product) => !product['purchased']);
    if (uncheckedIndex != -1 && uncheckedIndex < products.length - 1) {
      var uncheckedItems = products.sublist(uncheckedIndex + 1);
      uncheckedItems.sort((a, b) => a['purchased'] ? 1 : 0);
      products.replaceRange(uncheckedIndex + 1, products.length, uncheckedItems);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lista Zakupów'),
            ElevatedButton(
              onPressed: resetList,
              child: Text('Resetuj listę'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: productController,
                    decoration: InputDecoration(labelText: 'Nazwa produktu'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Ilość'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addProduct,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                if (index > 0 && products[index]['purchased'] != products[index - 1]['purchased']) {
                  // Insert a separator when the 'purchased' status changes
                  return Column(
                    children: [
                      Divider(), // Add a line separator
                      _buildProductCard(products, index),
                    ],
                  );
                } else {
                  return _buildProductCard(products, index);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(List<Map<String, dynamic>> sortedProducts, int index) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${sortedProducts[index]['name']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: sortedProducts[index]['purchased'] ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                '${sortedProducts[index]['quantity']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: sortedProducts[index]['purchased'] ? TextDecoration.lineThrough : TextDecoration.none,
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
                  icon: Icon(Icons.remove),
                  onPressed: () => removeProduct(index),
                ),
                IconButton(
                  icon: Icon(sortedProducts[index]['purchased'] ? Icons.check_box : Icons.check_box_outline_blank),
                  onPressed: () {
                    setState(() {
                      sortedProducts[index]['purchased'] = !sortedProducts[index]['purchased'];
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
