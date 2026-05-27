import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../services/food_service.dart';
import 'add_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  final service = SupabaseService();

  List<FoodModel> foods = [];

  List<FoodModel> favoriteFoods =
      [];

  bool isLoading = true;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    loadFoods();
  }

  Future<void> loadFoods() async {
    setState(() {
      isLoading = true;
    });

    final result =
        await service.getFoods();

    favoriteFoods = result
        .where((e) => e.isFavorite)
        .toList();

    setState(() {
      foods = result;

      isLoading = false;
    });
  }

  Color getStatusColor(
    String status,
  ) {
    switch (status) {
      case 'Fresh':
        return Colors.green;

      case 'Warning':
        return Colors.orange;

      default:
        return Colors.red;
    }
  }

  String getCountdown(
    String expiredDate,
  ) {
    final exp =
        DateTime.parse(expiredDate);

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

  Future<void> toggleFavorite(
    FoodModel food,
  ) async {
    await service.toggleFavorite(
      id: food.id,
      value: !food.isFavorite,
    );

    loadFoods();
  }

  Widget buildFoodList(
    List<FoodModel> data,
  ) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No Food Data",
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadFoods,

      child: ListView.builder(
        padding:
            const EdgeInsets.only(
          bottom: 100,
        ),

        itemCount: data.length,

        itemBuilder:
            (context, index) {
          final food = data[index];

          return Card(
            elevation: 4,

            margin:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(
                12,
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),

                    child: Image.network(
                      food.imageUrl,

                      width: 70,
                      height: 70,

                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) {
                        return Container(
                          width: 70,
                          height: 70,

                          color:
                              Colors.grey,

                          child:
                              const Icon(
                            Icons.image,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          food.name,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,

                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          "Expired: ${food.expiredDate}",
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          getCountdown(
                            food
                                .expiredDate,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,

                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              10,
                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              getStatusColor(
                            food.status,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),

                        child: Text(
                          food.status,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [
                          GestureDetector(
                            onTap: () {
                              toggleFavorite(
                                food,
                              );
                            },

                            child: Icon(
                              food.isFavorite
                                  ? Icons
                                      .favorite
                                  : Icons
                                      .favorite_border,

                              color:
                                  Colors.red,

                              size: 22,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          GestureDetector(
                            onTap:
                                () async {
                              await service
                                  .deleteFood(
                                food.id,
                              );

                              loadFoods();
                            },

                            child:
                                const Icon(
                              Icons.delete,

                              color:
                                  Colors.red,

                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget analyticsPage() {
    int fresh = foods
        .where(
          (e) =>
              e.status ==
              'Fresh',
        )
        .length;

    int warning = foods
        .where(
          (e) =>
              e.status ==
              'Warning',
        )
        .length;

    int expired = foods
        .where(
          (e) =>
              e.status ==
              'Expired',
        )
        .length;

    return SingleChildScrollView(
      padding:
          const EdgeInsets.all(20),

      child: Column(
        children: [
          analyticsCard(
            "Fresh Foods",
            fresh,
            Colors.green,
          ),

          analyticsCard(
            "Warning Foods",
            warning,
            Colors.orange,
          ),

          analyticsCard(
            "Expired Foods",
            expired,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget analyticsCard(
    String title,
    int value,
    Color color,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: color,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

        children: [
          Text(
            title,

            style: const TextStyle(
              color: Colors.white,

              fontSize: 18,
            ),
          ),

          Text(
            value.toString(),

            style: const TextStyle(
              color: Colors.white,

              fontSize: 28,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Widget currentPage() {
    switch (currentIndex) {
      case 0:
        return buildFoodList(
          foods,
        );

      case 1:
        return buildFoodList(
          favoriteFoods,
        );

      case 2:
        return analyticsPage();

      default:
        return buildFoodList(
          foods,
        );
    }
  }


  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor:
            Colors.green,

        title: const Text(
          "Smart Food Expiry",
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : currentPage(),

      floatingActionButton:
          currentIndex == 0
              ? FloatingActionButton(
                  backgroundColor:
                      Colors.green,

                  child: const Icon(
                    Icons.add,
                  ),

                  onPressed:
                      () async {
                    await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder:
                            (_) =>
                                const AddFoodPage(),
                      ),
                    );

                    loadFoods();
                  },
                )
              : null,

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor:
            Colors.green,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.favorite),
            label: "Favorite",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.bar_chart),
            label: "Analytics",
          ),
        ],
      ),
    );
  }
}