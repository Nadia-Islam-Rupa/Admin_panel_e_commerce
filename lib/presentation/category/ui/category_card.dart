import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: 150,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 180,

            child: Image.network(
              "https://becs-table.com.au/wp-content/uploads/2014/01/ice-cream-1.jpg",
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 10),
          Text("Total Users", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
