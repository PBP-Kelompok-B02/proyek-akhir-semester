import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/dashboard/widgets/form.dart';
import 'dart:convert';
import '../../internal/auth.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';

class AddFoodPage extends StatelessWidget {
  const AddFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StyledFoodForm();
  }
}