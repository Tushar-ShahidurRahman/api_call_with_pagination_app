import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pagination App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class HomeController extends GetxController {
  var posts = <dynamic>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  final int limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      isLoading.value = true;
      final apiUrl =
          'https://jsonplaceholder.typicode.com/posts?_start=0&_limit=$limit';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        posts.assignAll(responseData);
        isLoading.value = false;
        currentPage.value = 1;
      } else {
        isLoading.value = false;
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    }
  }

  void fetchNextPage() async {
    try {
      if (isLoading.value) return;

      isLoading.value = true;
      final apiUrl =
          'https://jsonplaceholder.typicode.com/posts?_start=${(currentPage.value - 1) * limit}&_limit=$limit';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        if (responseData.isEmpty) {
          // No more data available
          isLoading.value = false;
          return;
        }

        posts.addAll(responseData);
        isLoading.value = false;
        currentPage.value++;
      } else {
        isLoading.value = false;
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    }
  }
}
