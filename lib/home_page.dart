import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class MyHomePage extends StatelessWidget {
  final HomeController controller = Get.find();
  final ScrollController scrollController = ScrollController();

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.extentAfter == 0) {
        controller.fetchNextPage();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination App'),
      ),
      body: Obx(
            () => ListView.builder(
          controller: scrollController,
          itemCount: controller.posts.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < controller.posts.length) {
              final post = controller.posts[index];
              final postNumber = index + 1;

              return ListTile(
                title: Text('Post $postNumber: ${post['title']}'),
                subtitle: Text(post['body']),
              );
            } else {
              if (controller.isLoading.value) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (controller.posts.isEmpty) {
                return Center(child: Text('No posts available.'));
              } else {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}

