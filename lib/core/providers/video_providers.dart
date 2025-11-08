import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/video_model.dart';
import '../../domain/repositories/video_repository.dart';
import 'repository_providers.dart';
import '../../core/constants/app_constants.dart';

final videosProvider = StreamProvider.family<List<VideoModel>, VideoQueryParams>((ref, params) {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.getVideos(
    limit: params.limit,
    startAfter: params.startAfter,
    orderBy: params.orderBy,
  );
});

class VideoQueryParams {
  final int limit;
  final DateTime? startAfter;
  final String? orderBy;

  VideoQueryParams({
    this.limit = AppConstants.videosPerPage,
    this.startAfter,
    this.orderBy = 'createdAt',
  });
}

final videoControllerProvider = StateNotifierProvider.family<VideoController, AsyncValue<VideoModel?>, String>((ref, videoId) {
  return VideoController(ref.watch(videoRepositoryProvider), videoId);
});

class VideoController extends StateNotifier<AsyncValue<VideoModel?>> {
  final VideoRepository _repository;
  final String _videoId;

  VideoController(this._repository, this._videoId) : super(const AsyncValue.loading()) {
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    try {
      final video = await _repository.getVideoById(_videoId);
      state = AsyncValue.data(video);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> likeVideo(String userId) async {
    await _repository.likeVideo(_videoId, userId);
    await _loadVideo();
  }

  Future<void> unlikeVideo(String userId) async {
    await _repository.unlikeVideo(_videoId, userId);
    await _loadVideo();
  }

  Future<void> incrementViews() async {
    await _repository.incrementViews(_videoId);
  }
}

