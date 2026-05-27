import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/food_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<String> uploadImage(
    File file,
  ) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}.jpg";

    await supabase.storage
        .from('food-images')
        .upload(fileName, file);

    return supabase.storage
        .from('food-images')
        .getPublicUrl(fileName);
  }

  Future<void> addFood({
    required String name,
    required String imageUrl,
    required DateTime expiredDate,
    required String status,
  }) async {
    await supabase.from('foods').insert({
      'name': name,
      'image_url': imageUrl,
      'expired_date':
          expiredDate.toIso8601String(),
      'status': status,
      'is_favorite': false,
    });
  }

  Future<List<FoodModel>> getFoods() async {
    try {
      final response = await supabase
          .from('foods')
          .select()
          .order(
            'upload_date',
            ascending: false,
          );

      return response
          .map<FoodModel>(
            (e) => FoodModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteFood(
    String id,
  ) async {
    await supabase
        .from('foods')
        .delete()
        .eq('id', id);
  }

  Future<void> toggleFavorite({
    required String id,
    required bool value,
  }) async {
    await supabase
        .from('foods')
        .update({
          'is_favorite': value,
        })
        .eq('id', id);
  }
}