import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/home/domain/garment_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:demo/src/features/home/data/fashionapp_repository.dart';
import 'package:demo/src/features/home/providers/garments_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route<void> route({String? baseURL, http.Client? client}) =>
      MaterialPageRoute(
        builder:
            (_) => ChangeNotifierProvider(
              create:
                  (_) => GarmentsProvider(
                    repository: FashionAppRepository(
                      baseURL: baseURL,
                      client: client,
                    ),
                  )..getAllGarments(),
              child: HomeScreen(),
            ),
      );

  @override
  Widget build(BuildContext context) {
    final topwear = context.watch<GarmentsProvider>().topwearGarments;
    final bottomwear = context.watch<GarmentsProvider>().bottomwearGarments;

    return Selector<GarmentsProvider, String?>(
      selector: (context, provider) => provider.errorMessage,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, errorMessage, child) {
        if (errorMessage != null) {
          ShadToaster.of(context).show(
            ShadToast(
              alignment: Alignment.center,
              title: Text(AppStrings.SOMETHING_WENT_WRONG_ERROR_TITLE),
              description: Text(errorMessage),
            ),
          );
        }

        return child!;
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final orientationModifier =
                  MediaQuery.orientationOf(context) == Orientation.landscape
                      ? 2.5
                      : 1;

              final sectionHeight =
                  (constraints.maxHeight * 0.5) * orientationModifier;

              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: sectionHeight),
                          child: _GarmentSection(
                            title: AppStrings.TOP,
                            garments: topwear,
                            onItemTap:
                                (id) => context
                                    .read<GarmentsProvider>()
                                    .updateSelectedTopwearGarment(id),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 24)),
                      SliverToBoxAdapter(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: sectionHeight),
                          child: _GarmentSection(
                            title: AppStrings.BOTTOM,
                            garments: bottomwear,
                            onItemTap:
                                (id) => context
                                    .read<GarmentsProvider>()
                                    .updateSelectedBottomwearGarment(id),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                  Selector<
                    GarmentsProvider,
                    ({GarmentItem? topwear, GarmentItem? bottomwear})
                  >(
                    builder: (context, selected, child) {
                      final topwear = selected.topwear;
                      final bottomwear = selected.bottomwear;

                      if (topwear != null || bottomwear != null) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 12,
                              children: [
                                if (topwear != null)
                                  Transform.rotate(
                                    angle: 25,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.8,
                                            ),
                                            offset: Offset(0, 4),
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: topwear.displayUrl,
                                          fit: BoxFit.cover,
                                          height: 64,
                                          width: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (bottomwear != null)
                                  Transform.rotate(
                                    angle: -25,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.8,
                                            ),
                                            offset: Offset(0, 4),
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: bottomwear.displayUrl,
                                          fit: BoxFit.cover,
                                          height: 64,
                                          width: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SizedBox.shrink();
                    },
                    selector:
                        (context, provider) => (
                          topwear: provider.selectedTopwearGarment,
                          bottomwear: provider.selectedBottomwearGarment,
                        ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Selector<
          GarmentsProvider,
          ({GarmentItem? topwear, GarmentItem? bottomwear})
        >(
          builder: (context, selected, child) {
            final topwear = selected.topwear;
            final bottomwear = selected.bottomwear;

            void onDone() {
              context.read<GarmentsProvider>().resetSelectedGarments();
              Navigator.of(context).pop();
            }

            if (topwear != null && bottomwear != null) {
              return ShadIconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  showShadDialog(
                    context: context,
                    builder: (context) {
                      return ShadDialog(
                        radius: BorderRadius.circular(5),
                        padding: const EdgeInsets.all(8.0),
                        title: Text(AppStrings.SELECTED_GARMENTS_DIALOG_TITLE),
                        actions: [
                          ShadButton(
                            onPressed: onDone,
                            child: Text(
                              AppStrings.SELECTED_GARMENTS_DIALOG_DONE_BUTTON,
                            ),
                          ),
                        ],
                        child: Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        topwear.displayUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        bottomwear.displayUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }

            return SizedBox.shrink();
          },
          selector:
              (context, provider) => (
                topwear: provider.selectedTopwearGarment,
                bottomwear: provider.selectedBottomwearGarment,
              ),
        ),
      ),
    );
  }
}

class _GarmentSection extends StatelessWidget {
  const _GarmentSection({
    required this.title,
    required this.garments,
    required this.onItemTap,
  });

  final String title;
  final List<GarmentItem> garments;
  final void Function(String) onItemTap;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<GarmentsProvider>().isLoading;

    int mid = (garments.length / 2).ceil();

    return Column(
      spacing: 12.0,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Icon(Icons.arrow_forward_ios)],
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Divider()),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => SizedBox(width: 12),
              itemCount: isLoading ? 10 : mid,
              itemBuilder: (context, index) {
                if (isLoading) {
                  final orientationModifier =
                      MediaQuery.orientationOf(context) == Orientation.landscape
                          ? 2.5
                          : 1;

                  final dimension =
                      (MediaQuery.sizeOf(context).height * 0.2) *
                      orientationModifier;

                  return ColoredBox(
                    color: Colors.black,
                    child: SizedBox.square(dimension: dimension),
                  );
                }

                final garment = garments.elementAt(index);

                return Ink(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(garment.displayUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => onItemTap(garment.id),
                    child: AspectRatio(key: ObjectKey(garment), aspectRatio: 1),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => SizedBox(width: 12),
              itemCount: isLoading ? 10 : garments.length - mid,
              itemBuilder: (context, index) {
                if (isLoading) {
                  final orientationModifier =
                      MediaQuery.orientationOf(context) == Orientation.landscape
                          ? 2.5
                          : 1;

                  final dimension =
                      (MediaQuery.sizeOf(context).height * 0.2) *
                      orientationModifier;

                  return ColoredBox(
                    color: Colors.black,
                    child: SizedBox.square(dimension: dimension),
                  );
                }

                final garment = garments.elementAt(mid + index);

                return Ink(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(garment.displayUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => onItemTap(garment.id),
                    child: AspectRatio(key: ObjectKey(garment), aspectRatio: 1),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
