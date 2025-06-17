import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({super.key});

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  final DatabaseReference _menuRef =
      FirebaseDatabase.instance.ref().child('menu');

  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  Map<String, dynamic> menuData = {};

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  void _fetchMenuItems() {
    _menuRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          menuData = data.map((key, value) =>
              MapEntry(key.toString(), Map<String, dynamic>.from(value)));
        });
      } else {
        setState(() {
          menuData = {};
        });
      }
    });
  }

  void _addOrUpdateMenuItem([String? id]) {
    final foodname = foodNameController.text.trim();
    final rate = rateController.text.trim();
    final category = categoryController.text.trim();

    if (foodname.isEmpty || rate.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final item = {
      'foodname': foodname,
      'rate': rate,
      'category': category,
      'image':
"assets/image/Peri peri Alpham.jpg",
'isAvailable':true

    };

    if (id != null) {
      _menuRef.child(id).update(item);
    } else {
      _menuRef.push().set(item);
    }

    foodNameController.clear();
    rateController.clear();
    categoryController.clear();
  }

  void _deleteMenuItem(String id) {
    _menuRef.child(id).remove();
  }

  void _showEditDialog(String id, Map<String, dynamic> item) {
    foodNameController.text = item['foodname'] ?? '';
    rateController.text = item['rate'] ?? '';
    categoryController.text = item['category'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.green[50],
        title:
            const Text("Edit Menu Item", style: TextStyle(color: Colors.green)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: foodNameController,
                decoration: const InputDecoration(labelText: "Food Name")),
            TextField(
                controller: rateController,
                decoration: const InputDecoration(labelText: "Rate")),
            TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: "Category")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addOrUpdateMenuItem(id);
              Navigator.of(context).pop();
            },
            child: const Text("Update", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    foodNameController.clear();
    rateController.clear();
    categoryController.clear();

  showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.green[50],
        title: const Text("Add New Food Item",
            style: TextStyle(color: Colors.green)),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: foodNameController,
                  decoration: const InputDecoration(labelText: "Food Name"),
                ),
                TextField(
                  controller: rateController,
                  decoration: const InputDecoration(labelText: "Rate"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addOrUpdateMenuItem();
              Navigator.of(context).pop();
            },
            child: const Text("Add", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Colors.green;

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 130,
                ),
                Text(
                  "Exist ",
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  " Menu",
                  style: TextStyle(
                    fontSize: 38,
                    color: Color(0xFFFFBD04),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuData.length,
              itemBuilder: (context, index) {
                String id = menuData.keys.elementAt(index);
                Map<String, dynamic> item = menuData[id]!;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      '${item['foodname'] ?? 'Unnamed'} - ₹${item['rate'] ?? '0'}',
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      item['category'] ?? 'No category',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: greenColor),
                          onPressed: () => _showEditDialog(id, item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMenuItem(id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 🌟 FAB for Adding Item
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: _showAddDialog,
        tooltip: "Add Food Item",
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
