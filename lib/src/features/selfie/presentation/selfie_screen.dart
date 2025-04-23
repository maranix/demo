import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:demo/src/core/constants/app_strings.dart';
import 'package:demo/src/features/auth/providers/auth_provider.dart';
import 'package:demo/src/features/selfie/presentation/review_screen.dart';
import 'package:demo/src/features/selfie/providers/selfie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SelfieScreen extends StatelessWidget {
  const SelfieScreen({super.key});

  static Route<void> route() => MaterialPageRoute(
    builder:
        (_) => ChangeNotifierProvider(
          create: (_) => SelfieProvider(),
          child: _SelfiePage(),
        ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelfieProvider(),
      child: _SelfiePage(),
    );
  }
}

class _SelfiePage extends StatefulWidget {
  const _SelfiePage();

  @override
  State<_SelfiePage> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<_SelfiePage>
    with WidgetsBindingObserver {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      if (!mounted) return;

      final cameras = await availableCameras();
      final cameraDescription = cameras.firstWhereOrNull(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      if (cameraDescription != null) {
        await _initializeCameraController(cameraDescription);
        setState(() {});
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void showToast(String message) {
    ShadToaster.of(context).show(
      ShadToast(
        title: Text(AppStrings.SOMETHING_WENT_WRONG_ERROR_TITLE),
        description: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleTextStyle = textTheme.titleLarge;

    return Selector<SelfieProvider, bool>(
      builder: (context, complete, _) {
        if (complete) {
          return ReviewScreen();
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(AppStrings.SELFIE_SCREEN_TITLE, style: titleTextStyle),
                const Spacer(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth * 0.7;
                    final height = MediaQuery.sizeOf(context).height * 0.6;
                    return _buildCameraPreview(controller, width, height);
                  },
                ),
                const Spacer(),
                Selector<SelfieProvider, int>(
                  builder: (context, count, _) {
                    final maxCount =
                        context.read<SelfieProvider>().maxSelfieCount;
                    return Text(
                      "$count/$maxCount",
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  },
                  selector: (context, provider) => provider.currentIndex,
                ),
                ShadButton(
                  onPressed: () async {
                    if (controller == null ||
                        !controller!.value.isInitialized) {
                      return;
                    }
                    final provider = context.read<SelfieProvider>();

                    final selfie = await controller!.takePicture();
                    provider.captureSelfie(selfie);
                  },
                  leading: Icon(Icons.camera),
                  child: Text(AppStrings.SELFIE_SCREEN_TAKE_PICTURE_BUTTON),
                ),
                const Spacer(),
              ],
            ),
          ),
          floatingActionButton: ShadIconButton(
            onPressed: () => context.read<AuthProvider>().signOut(),
            icon: Icon(Icons.logout),
          ),
        );
      },
      selector: (context, provider) => provider.isComplete,
    );
  }

  Widget _buildCameraPreview(
    CameraController? controller,
    double width,
    double height,
  ) {
    if (controller != null && controller.value.isInitialized) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, maxHeight: height),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CameraPreview(controller),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ColoredBox(color: Colors.black),
      ),
    );
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (cameraController.value.hasError) {
        showToast('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showToast('You have denied camera access.');
        // iOS only
        case 'CameraAccessDeniedWithoutPrompt':
          showToast('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          showToast('Camera access is restricted.');
        case 'AudioAccessDenied':
          showToast('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          showToast('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          showToast('Audio access is restricted.');
        default:
          showToast('Unhandled error');
      }
    }

    if (mounted) {
      setState(() {});
    }
  }
}
