import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListScreenState createState() => _ProductListScreenState();
}


class _ProductListScreenState extends State<ProductListScreen> { //_は非公開クラス(クラスがウィジェットの内部状態を管理するため)
  List<Product> products = [
    Product(name: 'hot コーヒー', price: 300),
    Product(name: 'ice コーヒー', price: 300),
    Product(name: 'hot キャラメルマキアート', price: 400),
    Product(name: 'ice キャラメルマキアート', price: 400),
    Product(name: 'チョコドーナツ', price: 200),
    Product(name: 'シュガードーナツ', price: 200),
  ];

  List<Product> cart = [];

  int _currentIndex = 0;

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cafe'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[index].name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '¥${products[index].price}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(products[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to Cart: ${products[index].name}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              // Navigate to Menu screen
            } else if (_currentIndex == 1) {
              // Navigate to Cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartScreen(cart: cart),
                ),
              );
            }
          });
        },
      ),
    );
  }
}

class ShoppingCartScreen extends StatelessWidget {
  final List<Product> cart;

  const ShoppingCartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart[index].name),
            subtitle: Text('¥${cart[index].price}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () {
                Product removedProduct = cart[index];
                _showRemoveDialog(context, removedProduct);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showOrderDialog(context);
        },
        label: const Text('注文する'),
        icon: const Icon(Icons.shopping_cart),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, Product removedProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('カートから削除しますか'),
          content: Text('${removedProduct.name}をカートから削除しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeFromCart(context, removedProduct);
              },
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }

  void _removeFromCart(BuildContext context, Product removedProduct) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    cart.remove(removedProduct);
    _showSnackBar(context, '${removedProduct.name}をカートから削除しました');
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('注文しますか'),
          content: const Text('カートの商品を注文しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _placeOrder(context);
              },
              child: const Text('注文する'),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder(BuildContext context) {
    _showSnackBar(context, '注文が完了しました');
    Navigator.of(context).pop();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class Product {
  final String name;
  final int price;

  Product({required this.name, required this.price});
}
