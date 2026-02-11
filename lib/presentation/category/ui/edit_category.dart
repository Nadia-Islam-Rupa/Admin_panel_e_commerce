import 'package:flutter/material.dart';

class EditCategory extends StatelessWidget {
  const EditCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text('Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),

                border: Border.all(width: 0.5),
              ),
              child: const Center(child: Text('Image ')),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
