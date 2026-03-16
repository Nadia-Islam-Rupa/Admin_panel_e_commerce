import 'package:admin_pannel/presentation/category/ui/addnew_category.dart';

import 'package:admin_pannel/presentation/category/ui/category_list_page.dart';
import 'package:admin_pannel/presentation/home_dash/provider/dashboard_provider.dart';
import 'package:admin_pannel/presentation/home_dash/ui/container_home.dart';
import 'package:admin_pannel/presentation/product/ui/add_product.dart';
import 'package:admin_pannel/presentation/product/ui/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalUsers = ref.watch(totalUserCountProvider);
    final totalProducts = ref.watch(totalProductCountProvider);
    final totalCategories = ref.watch(totalCategoryCountProvider);

    String cardValue(AsyncValue<int> value) {
      return value.when(
        data: (count) => count.toString(),
        loading: () => '...',
        error: (_, _) => '0',
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text("Admin Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.8,
                children: [
                  ContainerHome(
                    title: 'Total Users',
                    value: cardValue(totalUsers),
                    icon: Icons.people_outline,
                    color: Colors.blue[300],
                  ),
                  ContainerHome(
                    title: 'Total Products',
                    value: cardValue(totalProducts),
                    icon: Icons.inventory_2_outlined,
                    color: Colors.teal[400],
                  ),
                  ContainerHome(
                    title: 'Total Categories',
                    value: cardValue(totalCategories),
                    icon: Icons.category_outlined,
                    color: Colors.orange[300],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manage Categories",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCategory()),
                      );
                    },
                    child: Text(
                      "Add New Category",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 190, child: CategoryListPage()),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manage Products",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddProduct()),
                      );
                    },
                    child: Text(
                      "Add New Product",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 190, child: ProductListPage()),
            ],
          ),
        ),
      ),
    );
  }
}
