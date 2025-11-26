// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:instagram_app_clone/common/components/animations/widgets/loading_animation_widget.dart';
// import 'package:instagram_app_clone/common/components/animations/widgets/small_error_animation_widget.dart';
// import 'package:instagram_app_clone/features/image_upload/models/thumbnail_request.dart';
// import 'package:instagram_app_clone/features/image_upload/provider/thumbnail_provider.dart';

// class FileThumbnailView extends ConsumerWidget {
//   final ThumbNailRequest thumbNailRequest;
//   const FileThumbnailView({required this.thumbNailRequest, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final thumbnail = ref.watch(thumbnailProvider(
//       thumbNailRequest,
//     ));
//     return thumbnail.when(
//       data: (imageWithAspectRatio) => AspectRatio(
//         aspectRatio: imageWithAspectRatio.aspectRatio,
//         child: imageWithAspectRatio.image,
//       ),
//       error: (_, __) => const SmallErrorAnimationWidget(),
//       loading: () => const LoadingAnimationWidget(),
//     );
//   }
// }
