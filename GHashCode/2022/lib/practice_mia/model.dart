/// Data Server is the root model for the
/// solution.
///
/// Author: https://github.com/vincenzopalazzo
class DataServer {
  final List<Video> videos;
  final List<Endpoint> endpoints;
  final List<Request> requests;
  final List<CacheServer> cacheServers;
  int sizeCache;

  /// This is the result mapping, where
  /// an list of video is mapping to a int that is the idx of te
  /// cache server
  Map<int, Set<Video>> requestMapping = {};

  DataServer(
      {required this.videos,
      required this.endpoints,
      required this.requests,
      required this.cacheServers,
      required this.sizeCache});

  @override
  String toString() {
    return 'DataServer{videos: $videos, endpoints: $endpoints, requests: $requests}';
  }
}

/// Author: https://github.com/vincenzopalazzo
class Video {
  final int id;

  /// The size of the video in MB
  final int size;

  Video({required this.id, required this.size});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Video && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Video{size: $size}';
  }
}

/// Author: https://github.com/vincenzopalazzo
class Endpoint {
  final int id;

  /// The latency with data server
  final int latency;
  final List<CacheServer> latencyFromServer;

  Endpoint(
      {required this.id,
      required this.latency,
      this.latencyFromServer = const []});

  void addLatencyFromServer(
      {required int serverID,
      required int sizeServer,
      required int locLatency}) {
    latencyFromServer
        .add(CacheServer(id: serverID, size: sizeServer, latency: locLatency));
  }

  @override
  String toString() {
    return 'Endpoint{latency: $latency, latencyFromServer: $latencyFromServer}';
  }
}

/// Author: https://github.com/vincenzopalazzo
class CacheServer extends Comparable {
  final int id;
  final int latency;
  int size;

  CacheServer({required this.id, required this.size, required this.latency});

  @override
  String toString() {
    return 'CacheServer{id: $id, latency: $size}';
  }

  @override
  int compareTo(other) {
    var server = other as CacheServer;
    if (latency < server.latency) {
      return -1;
    } else if (latency > server.latency) {
      return 1;
    }
    return 0;
  }
}

class Request extends Comparable {
  final int nRequests;
  final Video video;
  final int endpoint;

  Request(
      {required this.nRequests, required this.video, required this.endpoint});

  @override
  int compareTo(other) {
    var withReq = other as Request;
    if (nRequests < withReq.nRequests) {
      return 1;
    } else if (nRequests > withReq.nRequests) {
      return -1;
    }
    return 0;
  }

  @override
  String toString() {
    return 'Request{time: $nRequests, video: $video, endpoint: $endpoint}';
  }
}
