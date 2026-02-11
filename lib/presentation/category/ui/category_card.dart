import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.push('/products/${category.id}');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            boxShadow: const [
              BoxShadow(color: Color(0xFFE9E8E8), blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: 120,

                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwClYnbUMUHxAlax5R5iONJ1VwV4AkyWqBOAuOm_KPw-MKp_DF5sA-oBKblJEn_0TzYPtHNi3QriGBmMYFh2jYctiSct8kl7RUGM10uA&s',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Category Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
