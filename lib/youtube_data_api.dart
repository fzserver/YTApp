import 'dart:io';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart';

import 'package:flutter/foundation.dart';

class YouTubeDataAPI {
  _Videos _videos;
  _Videos get videos => _videos;

  _Channels _channels;
  _Channels get channels => _channels;

  _Playlists _playlists;
  _Playlists get playlists => _playlists;

  YouTubeDataAPI._(String apiKey, Client httpClient) : assert(apiKey != null) {
    _videos = _Videos(apiKey, httpClient);
    _channels = _Channels(apiKey, httpClient);
    _playlists = _Playlists(apiKey, httpClient);
  }

  factory YouTubeDataAPI({@required String apiKey, Client httpClient}) {
    httpClient = httpClient ?? Client();

    return new YouTubeDataAPI._(apiKey, httpClient);
  }
}

//region Enumerations

enum _YouTubeSearchType {
  video,
  channel,
  playlist,
}

enum YouTubeVideoCaption {
  /// Do not filter results based on caption availability.
  any,

  /// Only include videos that have captions.
  closedCaption,

  /// Only include videos that do not have captions.
  none,
}

enum YouTubeChannelType {
  /// Return all channels.
  any,

  /// Only retrieve shows.
  show,
}

enum YouTubeEventType {
  /// Only include completed broadcasts.
  completed,

  /// Only include active broadcasts.
  live,

  /// Only include upcoming broadcasts.
  upcoming,
}

enum YouTubeVideoDefinition {
  /// Return all videos, regardless of their resolution.
  any,

  /// Only retrieve HD videos.
  high,

  /// Only retrieve videos in standard definition.
  standard,
}

enum YouTubeSearchOrder {
  /// Resources are sorted in reverse chronological order based on the date they were created.
  date,

  /// Resources are sorted from highest to lowest rating.
  rating,

  ///Resources are sorted based on their relevance to the search query.
  ///This is the default value for this parameter.
  relevance,

  /// Resources are sorted alphabetically by title.
  title,

  /// Channels are sorted in descending order of their number of uploaded videos.
  videoCount,

  /// Resources are sorted from highest to lowest number of views.
  /// For live broadcasts, videos are sorted by number of concurrent viewers while the broadcasts are ongoing.
  viewCount,
}

enum YouTubeSafeSearch {
  /// YouTube will filter some content from search results and, at the least, will filter content that is restricted in your locale. Based on their content, search results could be removed from search results or demoted in search results. This is the default parameter value.
  moderate,

  /// YouTube will not filter the search result set.
  none,

  /// YouTube will try to exclude all restricted content from the search result set. Based on their content, search results could be removed from search results or demoted in search results.
  strict,
}

enum YouTubeVideoDuration {
  /// Do not filter video search results based on their duration. This is the default value.
  any,

  /// Only include videos longer than 20 minutes.
  long,

  /// Only include videos that are between four and 20 minutes long (inclusive).
  medium,

  /// Only include videos that are less than four minutes long.
  short,
}

enum YouTubeVideoLicense {
  /// Return all videos, regardless of which license they have, that match the query parameters.
  any,

  /// Only return videos that have a Creative Commons license. Users can reuse videos with this license in other videos that they create.
  creativeCommon,

  /// Only return videos that have the standard YouTube license.
  youtube,
}

enum YouTubeVideoType {
  ///  Return all videos.
  any,

  /// Only retrieve episodes of shows.
  episode,

  /// Only retrieve movies.
  movie,
}

//endregion

//region Base classes

abstract class _Base {
  final String apiKey;
  final Client httpClient;

  const _Base(this.apiKey, this.httpClient);

  Future<SearchResultModel> _search(_YouTubeSearchType type, String query, {SearchOptions options}) async {
    Map<String, dynamic> params = {
      'key': apiKey,
      'part': 'snippet',
    };

    if (query != null) {
      params.addAll({'q': query});
    }

    if (type != null) {
      params.addAll({'type': type.toString().split('.').last});
    }

    if (options != null) {
      if (options.pageToken != null) {
        params.addAll({'pageToken': options.pageToken});
      }

      if (options.pageSize != null) {
        params.addAll({'maxResults': options.pageSize.toString()});
      }

      if (options.order != null) {
        params.addAll({'order': options.order.toString().split('.').last});
      }

      if (options.channelType != null) {
        params.addAll({'channelType': options.channelType.toString().split('.').last});
      }

      if (options.regionCode != null) {
        params.addAll({'regionCode': options.regionCode});
      }

      if (options.safeSearch != null) {
        params.addAll({'safeSearch': options.safeSearch.toString().split('.').last});
      }

      switch (type) {
        case _YouTubeSearchType.video:
          if (options.channelId != null) {
            params.addAll({
              'channelId': options.channelId,
            });
          }

          if (options.eventType != null) {
            params.addAll({
              'eventType': options.eventType.toString().split('.').last,
            });
          }

          if (options.videoCaption != null) {
            params.addAll({
              'videoCaption': options.videoCaption.toString().split('.').last,
            });
          }

          if (options.videoLicense != null) {
            params.addAll({
              'videoLicense': options.videoLicense.toString().split('.').last,
            });
          }

          if (options.videoType != null) {
            params.addAll({
              'videoType': options.videoType.toString().split('.').last,
            });
          }

          if (options.videoDuration != null) {
            params.addAll({
              'videoDuration': options.videoDuration.toString().split('.').last,
            });
          }

          if (options.videoDefinition != null) {
            params.addAll({
              'videoDefinition': options.videoDefinition.toString().split('.').last,
            });
          }

          break;
        case _YouTubeSearchType.channel:
          break;
        case _YouTubeSearchType.playlist:
          break;
      }
    }

    Uri uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'youtube/v3/search',
      queryParameters: params,
    );

    final response = await httpClient.get(uri);
    if (response.statusCode == HttpStatus.ok) {
      return SearchResultModel._fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}

// Result models
abstract class _BaseResultModel {
  int _totalResults;
  int get totalResults => _totalResults;

  int _resultsPerPage;
  int get resultsPerPage => _resultsPerPage;

  String _prevPageToken;
  String get prevPageToken => _prevPageToken;

  String _nextPageToken;
  String get nextPageToken => _nextPageToken;

  _BaseResultModel(Map<String, dynamic> json) {
    this._prevPageToken = json['prevPageToken'] as String;
    this._nextPageToken = json['nextPageToken'] as String;
    this._totalResults = json['pageInfo']['totalResults'] as int;
    this._resultsPerPage = json['pageInfo']['resultsPerPage'] as int;
  }
}

//endregion

//region Type classes

class _Videos extends _Base {
  const _Videos(String apiKey, Client httpClient) : super(apiKey, httpClient);

  Future<SearchResultModel> search(String query, {SearchOptions options}) {
    return _search(_YouTubeSearchType.video, query, options: options);
  }

  Future<VideoResultModel> fetchDetails(String videoId) async {
    Uri uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'youtube/v3/videos',
      queryParameters: {
        'id': videoId,
        'key': apiKey,
        'part': 'snippet,statistics',
      },
    );

    final response = await httpClient.get(uri);
    if (response.statusCode == HttpStatus.ok) {
      return VideoResultModel._fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}

class _Channels extends _Base {
  const _Channels(String apiKey, Client httpClient) : super(apiKey, httpClient);

  Future<SearchResultModel> search(String query, {SearchOptions options}) {
    return _search(_YouTubeSearchType.channel, query, options: options);
  }
}

class _Playlists extends _Base {
  const _Playlists(String apiKey, Client httpClient) : super(apiKey, httpClient);

  Future<SearchResultModel> search(String query, {SearchOptions options}) {
    return _search(_YouTubeSearchType.playlist, query, options: options);
  }

  Future<PlaylistResultModel> fetchVideos(String playlistId, {int pageSize = 5, String pageToken}) async {
    Uri uri = Uri(
      scheme: 'https',
      host: 'www.googleapis.com',
      path: 'youtube/v3/playlistItems',
      queryParameters: {
        'key': apiKey,
        'part': 'snippet,contentDetails',
        'pageToken': pageToken ?? '',
        'playlistId': playlistId ?? '',
        'maxResults': pageSize?.toString(),
      },
    );

    final response = await httpClient.get(uri);
    if (response.statusCode == HttpStatus.ok) {
      return PlaylistResultModel._fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}

//endregion

//region Search options

class SearchOptions {
  /// The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  /// Acceptable values are 0 to 50, inclusive. The default value is 5.
  int pageSize;

  /// The pageToken parameter identifies a specific page in the result set that should be returned.
  /// In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  String pageToken;

  /// The channelId parameter indicates that the API response should only contain resources created by the channel.
  String channelId;

  /// The order parameter specifies the method that will be used to order resources in the API response.
  /// The default value is relevance.
  YouTubeSearchOrder order;

  /// The channelType parameter lets you restrict a search to a particular type of channel.
  YouTubeChannelType channelType;

  /// The eventType parameter restricts a search to broadcast events.
  YouTubeEventType eventType;

  /// The regionCode parameter instructs the API to return search results for videos that can be viewed in the specified country.
  String regionCode;

  /// The regionCode parameter instructs the API to return search results for videos that can be viewed in the specified country.
  YouTubeSafeSearch safeSearch;

  /// The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions.
  YouTubeVideoCaption videoCaption;

  /// The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos.
  YouTubeVideoLicense videoLicense;

  /// The videoType parameter lets you restrict a search to a particular type of videos.
  YouTubeVideoType videoType;

  /// The videoDuration parameter filters video search results based on their duration.
  YouTubeVideoDuration videoDuration;

  /// The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available.
  YouTubeVideoDefinition videoDefinition;

  SearchOptions({
    this.pageSize,
    this.pageToken,
    this.channelId,
    this.order,
    this.channelType,
    this.eventType,
    this.regionCode,
    this.safeSearch,
    this.videoCaption,
    this.videoLicense,
    this.videoType,
    this.videoDuration,
    this.videoDefinition,
  });

  SearchOptions copyWith({
    int pageSize,
    String pageToken,
    String channelId,
    YouTubeSearchOrder order,
    YouTubeChannelType channelType,
    YouTubeEventType eventType,
    String regionCode,
    YouTubeSafeSearch safeSearch,
    YouTubeVideoCaption videoCaption,
    YouTubeVideoLicense videoLicense,
    YouTubeVideoType videoType,
    YouTubeVideoDuration videoDuration,
    YouTubeVideoDefinition videoDefinition,
  }) {
    return SearchOptions(
      pageSize: pageSize ?? this.pageSize,
      pageToken: pageToken ?? this.pageToken,
      channelId: channelId ?? this.channelId,
      order: order ?? this.order,
      channelType: channelType ?? this.channelType,
      eventType: eventType ?? this.eventType,
      regionCode: regionCode ?? this.regionCode,
      safeSearch: safeSearch ?? this.safeSearch,
      videoCaption: videoCaption ?? this.videoCaption,
      videoLicense: videoLicense ?? this.videoLicense,
      videoType: videoType ?? this.videoType,
      videoDuration: videoDuration ?? this.videoDuration,
      videoDefinition: videoDefinition ?? this.videoDefinition,
    );
  }
}

//endregion

//region Result models

class SearchResultModel extends _BaseResultModel {
  List<SearchItemResultModel> _items;
  List<SearchItemResultModel> get items => _items;

  SearchResultModel._fromJson(Map<String, dynamic> json) : super(json) {
    this._items = json["items"].map<SearchItemResultModel>((item) => SearchItemResultModel._fromJson(item)).toList();
  }
}

class VideoResultModel extends _BaseResultModel {
  VideoItemResultModel _item;
  VideoItemResultModel get item => _item;

  VideoResultModel._fromJson(Map<String, dynamic> json) : super(json) {
    this._item = VideoItemResultModel._fromJson(json["items"][0]);
  }
}

class PlaylistResultModel extends _BaseResultModel {
  List<PlaylistItemResultModel> _items;
  List<PlaylistItemResultModel> get items => _items;

  PlaylistResultModel._fromJson(Map<String, dynamic> json) : super(json) {
    this._items = json["items"].map<PlaylistItemResultModel>((item) => PlaylistItemResultModel._fromJson(item)).toList();
  }
}

//endregion

//region Item result models

class SearchItemResultModel {
  DateTime _publishedAt;
  DateTime get publishedAt => _publishedAt;

  String _id;
  String get id => _id;

  String _channelId;
  String get channelId => _channelId;

  String _title;
  String get title => _title;

  String _description;
  String get description => _description;

  String _channelTitle;
  String get channelTitle => _channelTitle;

  String _defaultThumbnail;
  String get defaultThumbnail => _defaultThumbnail;

  String _mediumThumbnail;
  String get mediumThumbnail => _mediumThumbnail;

  String _highThumbnail;
  String get highThumbnail => _highThumbnail;

  _YouTubeSearchType _type;
  _YouTubeSearchType get type => _type;

  SearchItemResultModel._fromJson(Map<String, dynamic> json) {
    _YouTubeSearchType type;

    String id = '';
    String kind = (json['id']['kind'] as String).split('#').last;

    if (kind.compareTo('video') == 0) {
      type = _YouTubeSearchType.video;
      id = json['id']['videoId'] as String;
    } else if (kind.compareTo('channel') == 0) {
      type = _YouTubeSearchType.channel;
      id = json['id']['channelId'] as String;
    } else if (kind.compareTo('playlist') == 0) {
      type = _YouTubeSearchType.playlist;
      id = json['id']['playlistId'] as String;
    }

    this._id = id;
    this._type = type;
    this._title = json['snippet']['title'] as String;
    this._channelId = json['snippet']['channelId'] as String;
    this._description = json['snippet']['description'] as String;
    this._channelTitle = json['snippet']['channelTitle'] as String;
    this._publishedAt = DateTime.parse(json['snippet']['publishedAt'] as String);
    this._defaultThumbnail = json['snippet']['thumbnails']['default']['url'] as String;
    this._mediumThumbnail = json['snippet']['thumbnails']['medium']['url'] as String;
    this._highThumbnail = json['snippet']['thumbnails']['high']['url'] as String;
  }
}

class VideoItemResultModel {
  String _videoId;
  String get videoId => _videoId;

  DateTime _videoPublishedAt;
  DateTime get videoPublishedAt => _videoPublishedAt;

  String _channelId;
  String get channelId => _channelId;

  String _title;
  String get title => _title;

  String _description;
  String get description => _description;

  String _channelTitle;
  String get channelTitle => _channelTitle;

  String _defaultThumbnail;
  String get defaultThumbnail => _defaultThumbnail;

  String _mediumThumbnail;
  String get mediumThumbnail => _mediumThumbnail;

  String _highThumbnail;
  String get highThumbnail => _highThumbnail;

  String _standardThumbnail;
  String get standardThumbnail => _standardThumbnail;

  String _maxResThumbnail;
  String get maxResThumbnail => _maxResThumbnail;

  String _categoryId;
  String get categoryId => _categoryId;

  List<String> _tags;
  List<String> get tags => _tags;

  String _viewCount;
  String get viewCount => _viewCount;

  String _likeCount;
  String get likeCount => _likeCount;

  String _dislikeCount;
  String get dislikeCount => _dislikeCount;

  String _favoriteCount;
  String get favoriteCount => _favoriteCount;

  String _commentCount;
  String get commentCount => _commentCount;

  VideoItemResultModel._fromJson(Map<String, dynamic> json) {
    this._videoId = json['id'] as String;
    this._videoPublishedAt = DateTime.parse(json['snippet']['publishedAt'] as String);
    this._title = json['snippet']['title'] as String;
    this._description = json['snippet']['description'] as String;
    this._defaultThumbnail = json['snippet']['thumbnails']['default']['url'] as String;
    this._mediumThumbnail = json['snippet']['thumbnails']['medium']['url'] as String;
    this._highThumbnail = json['snippet']['thumbnails']['high']['url'] as String;
    this._standardThumbnail = json['snippet']['thumbnails']['standard']['url'] as String;
    this._maxResThumbnail = json['snippet']['thumbnails']['maxres']['url'] as String;
    this._channelTitle = json['snippet']['channelTitle'] as String;
    this._categoryId = json['snippet']['categoryId'] as String;
    this._tags = List<String>.from(json['snippet']['tags']);
    this._viewCount = json['statistics']['viewCount'] as String;
    this._likeCount = json['statistics']['likeCount'] as String;
    this._dislikeCount = json['statistics']['dislikeCount'] as String;
    this._favoriteCount = json['statistics']['favoriteCount'] as String;
    this._commentCount = json['statistics']['commentCount'] as String;
  }
}

class PlaylistItemResultModel {
  String _videoId;
  String get videoId => _videoId;

  DateTime _videoPublishedAt;
  DateTime get videoPublishedAt => _videoPublishedAt;

  String _playlistId;
  String get playlistId => _playlistId;

  String _channelId;
  String get channelId => _channelId;

  String _title;
  String get title => _title;

  String _description;
  String get description => _description;

  String _channelTitle;
  String get channelTitle => _channelTitle;

  String _defaultThumbnail;
  String get defaultThumbnail => _defaultThumbnail;

  String _mediumThumbnail;
  String get mediumThumbnail => _mediumThumbnail;

  String _highThumbnail;
  String get highThumbnail => _highThumbnail;

  PlaylistItemResultModel._fromJson(Map<String, dynamic> json) {
    this._videoId = json['contentDetails']['videoId'] as String;
    this._videoPublishedAt = DateTime.parse(json['contentDetails']['videoPublishedAt'] as String);
    this._playlistId = json['snippet']['playlistId'] as String;
    this._title = json['snippet']['title'] as String;
    this._description = json['snippet']['description'] as String;
    this._defaultThumbnail = json['snippet']['thumbnails']['default']['url'] as String;
    this._mediumThumbnail = json['snippet']['thumbnails']['medium']['url'] as String;
    this._highThumbnail = json['snippet']['thumbnails']['high']['url'] as String;
    this._channelTitle = json['snippet']['channelTitle'] as String;
  }
}

//endregion
