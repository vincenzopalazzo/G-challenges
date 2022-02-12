import 'dart:math';
import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_mia/model.dart';

/// Solution of the Hash Code 2017 during the code exercise
/// of Mia platform.
///
/// Author: https://github.com/vincenzopalazzo
class PracticeMia extends Solution<DataServer> {
  @override
  DataServer parse() {
    var dataServer = DataServer(
      videos: List.empty(growable: true),
      endpoints: List.empty(growable: true),
      requests: List.empty(growable: true),
      sizeCache: 0,
      cacheServers: List.empty(growable: true),
    );

    // The input reader is from the following pattern
    // nVideo, nEndPoint, nRequest, nCache, sizeCache
    var sizeInput = input!.readInts(5);
    assert(sizeInput.length == 5);
    var nVideo = sizeInput[0];
    var nEndPoint = sizeInput[1];
    var nRequest = sizeInput[2];
    var nCache = sizeInput[3];
    dataServer.sizeCache = sizeInput[4];

    // The next line contains all the size of the video
    var sizeVideos = input!.readInts(nVideo);
    for (var index = 0; index < nVideo; index++) {
      var video = Video(id: index, size: sizeVideos[index]);
      dataServer.videos.add(video);
    }

    for (var index = 0; index < nEndPoint; index++) {
      var rawEndPoint = input!.readInts(2);
      var endPoint = Endpoint(
          id: index,
          latency: rawEndPoint[0],
          latencyFromServer: List.empty(growable: true));
      for (var idx = 0; idx < rawEndPoint[1]; idx++) {
        var rawCacheServer = input!.readInts(2);
        endPoint.addLatencyFromServer(
            serverID: rawCacheServer[0],
            locLatency: rawCacheServer[1],
            sizeServer: dataServer.sizeCache);
      }
      dataServer.endpoints.add(endPoint);
    }

    for (var idx = 0; idx < nRequest; idx++) {
      // Patter: 1500 requests for video 3 coming from endpoint 0.
      var rawRequest = input!.readInts(3);
      var request = Request(
          nRequests: rawRequest[2],
          video: dataServer.videos[rawRequest[0]],
          endpoint: rawRequest[1]);
      dataServer.requests.add(request);
    }
    for (var idx = 0; idx < nCache; idx++) {
      var server =
          CacheServer(id: idx, size: dataServer.sizeCache, latency: -1);
      dataServer.cacheServers.add(server);
    }
    this.log(dataServer);
    return dataServer;
  }

  /// Given a description of cache servers, network endpoints and videos, along with predicted requests for
  // individual videos, decide which videos to put in which cache server in order to minimize the average
  // waiting time for all requests
  @override
  DataServer solve(DataServer input) {
    /// 1. all the possible cache server are
    /// the cache server where the endpoints are
    /// connected and store the max size of the cache server.
    // 2. Sort the request by the nRequest made, remove
    // all the request of video that don't fit inside the cache.
    // 3. For each request map take random number and fill the map.
    for (var endPoint in input.endpoints) {
      if (endPoint.latencyFromServer.isEmpty) {
        continue;
      }

      for (var cache in endPoint.latencyFromServer) {
        input.requestMapping[cache.id] = {};
      }
    }

    input.requests.sort();

    for (var request in input.requests) {
      var cacheEntrypoint = input.endpoints[request.endpoint].latencyFromServer;
      cacheEntrypoint.sort();
      for (var server in cacheEntrypoint) {
        var serverState = input.cacheServers[server.id];
        if (serverState.size < request.video.size) {
          continue;
        }
        serverState.size -= request.video.size;
        input.requestMapping[serverState.id]!.add(request.video);
        break;
      }
    }
    this.log(input);
    return input;
  }

  @override
  void store(result) {
    var dataServer = result as DataServer;
    // Tot size cache server used
    output!.writeLine(dataServer.requestMapping.length.toString());
    // Cache server 0 contains only video 2.
    // -> 0 2
    // Cache server 1 contains videos 3 and 1.
    // -> 1 3 1
    // Cache server 2 contains videos 0 and 1.
    // -> 2 0 1
    var keys = dataServer.requestMapping.keys.toList().toList();
    keys.sort();
    for (var key in keys) {
      rawLog("Mapping request: ${key.toString()}");
      var videos = dataServer.requestMapping[key]!;
      var resultLine = "$key ";
      assert(videos.isNotEmpty);
      for (var video in videos) {
        resultLine += "${video.id} ";
      }
      rawLog(resultLine);
      output!.writeLine(resultLine.trim());
    }
  }
}
