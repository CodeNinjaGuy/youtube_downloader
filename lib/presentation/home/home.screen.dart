import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:youtube_dl/presentation/mywidgets.dart';
import 'package:group_radio_button/group_radio_button.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeScreen'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextField(
                  caption: "YouTube URL oder Suche",
                  textEditingController: controller.urlTextEditingController,
                  icon: Icons.youtube_searched_for_sharp,
                  inputFormat: [
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                  keyboardFormat: TextInputType.url,
                  onChanged: (value) {},
                  onPress: () {
                    controller.searchForVideos(
                        controller.urlTextEditingController.text);
                  },
                ),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.videoResult.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 2,
                        child: ListTile(
                          
                          title: Text(controller.videoResult[index].title),
                          subtitle: Text("${controller.videoResult[index].description}\n${controller.videoResult[index].duration}"),
                          leading: Image.network(controller.videoResult[index].thumbnail.small.url??""),
                          trailing: IconButton(icon: Icon(Icons.download),onPressed: () {
                          
                            controller.openDirecoryForSave(context: context, url: controller.videoResult[index].id??"");
                          },),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
