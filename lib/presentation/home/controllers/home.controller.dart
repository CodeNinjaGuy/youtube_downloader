import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_api/youtube_api.dart';

class HomeController extends GetxController {
  final _movie = Movie().obs;
  var urlTextEditingController = TextEditingController();
  final _status = [
    "Audio only as MP3 highest bit rate",
    "HigestVideoQuality",
    "highest Video without Sound"
  ];
  var verticalValue = "".obs;
  var loading = false.obs;

static String key = 'AIzaSyA52gcLeBPhW_O1VCutTA5Pq578Ot0JthA';
YoutubeAPI ytApi = new YoutubeAPI(key);
var videoResult = <YouTubeVideo>[].obs;

searchForVideos(String query)async{

  try {
    videoResult.value = await ytApi.search(query);
  } catch (e) {
     Get.snackbar("Fehler", e.toString());
  }
  

  //verticalValue.refresh();
}


  Movie get movie => _movie.value;
  get status => _status;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    urlTextEditingController.dispose();
    super.dispose();
  }

  openDirecoryForSave(
      {required BuildContext context, required String url}) async {
    loading.value = true;
    final Directory? downloadsDir = await getDownloadsDirectory();

    String? path = downloadsDir!.path;
    if (path != null) {
      await getMetaDataFromVideo(url, path);
    }
  }

  getMetaDataFromVideo(String url, String path) async {
    // You can provide either a video ID or URL as String or an instance of `VideoId`.
    try {
      var yt = YoutubeExplode();
      var video = await yt.videos.get(url); // Returns a Video instance.
      _movie.value.title = video.title; // "Scamazon Prime"
      _movie.value.author = video.author; // "Jim Browning"
      _movie.value.duration = video.duration;
      _movie.refresh();
      await download(path,url);
    } catch (e) {
      Get.snackbar("Fehler", e.toString());
    }
  }

  download(String path,String url) async {
    var yt = YoutubeExplode();
    verticalValue.value = "Audio only as MP3 highest bit rate";
    var manifest = await yt.videos.streamsClient
        .getManifest(url);
    switch (verticalValue.value) {
      case "HigestVideoQuality":
        var streamInfo = manifest.muxed.withHighestBitrate();
        var stream = yt.videos.streamsClient.get(streamInfo);

        // Open a file for writing.
        
        var file = File("$path/${movie.title?.trim().replaceAll(".", "-").replaceAll("*",'')??"no-title"}.mp4");
        var fileStream = file.openWrite();

        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();
        yt.close();
        loading.value = false;
        break;
      case "Audio only as MP3 highest bit rate":

         var streamInfo = manifest.audioOnly.withHighestBitrate();
        var stream = yt.videos.streamsClient.get(streamInfo);

        // Open a file for writing.
        
        var file = File("$path/${movie.title?.trim().replaceAll(".", "-").replaceAll("*",'')??"no-title"}.mp3");
        var fileStream = file.openWrite();

        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();
        yt.close();
        loading.value = false;

        break;
      case "highest Video without Sound":
        var streamInfo3 =
            manifest.videoOnly.where((e) => e.container == Container);
        break;
      default:
    }
  }
}

class Movie {
  String? title;
  String? author;
  Duration? duration;
}
