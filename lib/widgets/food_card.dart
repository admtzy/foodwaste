import 'package:flutter/material.dart';

import '../models/food_model.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;

  final VoidCallback onDelete;
  final VoidCallback onFavorite;

  const FoodCard({
    super.key,
    required this.food,
    required this.onDelete,
    required this.onFavorite,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'Fresh':
        return Colors.green;

      case 'Warning':
        return Colors.orange;

      default:
        return Colors.red;
    }
  }

  String getCountdown(String expiredDate) {
    final exp = DateTime.parse(expiredDate);

    final diff = exp
        .difference(DateTime.now())
        .inDays;

    if (diff < 0) {
      return "Expired";
    }

    if (diff == 0) {
      return "Expired Today";
    }

    return "$diff days left";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      margin: const EdgeInsets.all(10),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.all(10),

        leading: ClipRRect(
          borderRadius:
              BorderRadius.circular(10),

          child: Image.network(
            food.imageUrl,

            width: 70,
            height: 70,

            fit: BoxFit.cover,
          ),
        ),

        title: Text(
          food.name,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 5),

            Text(
              "Expired: ${food.expiredDate}",
            ),

            const SizedBox(height: 5),

            Text(
              getCountdown(food.expiredDate),
            ),
          ],
        ),

        trailing: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),

              decoration: BoxDecoration(
                color: getStatusColor(
                  food.status,
                ),

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child: Text(
                food.status,

                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                GestureDetector(
                  onTap: onFavorite,

                  child: Icon(
                    food.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,

                    color: Colors.red,
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: onDelete,

                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}