import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:research_mantra_official/constants/assets.dart';
import 'package:research_mantra_official/constants/env_config.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/data/models/product_details_content_api_response_model.dart';
import 'package:research_mantra_official/providers/check_connection_provider.dart';
import 'package:research_mantra_official/providers/learning/indicator_description/indicator_description_provider.dart';
import 'package:research_mantra_official/services/check_connectivity.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/empty_contents/no_content_widget.dart';
import 'package:research_mantra_official/ui/components/king_research_loader/kingresearch_loader.dart';
import 'package:research_mantra_official/ui/router/app_routes.dart';
import 'package:research_mantra_official/ui/screens/learning/widgets/examples_screen.dart';
import 'package:research_mantra_official/ui/screens/profile/widgets/full_screen_image_dialog.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';

class DescriptionPageIndicator extends ConsumerStatefulWidget {
  final int id;
  final String endPoint;

  const DescriptionPageIndicator({
    super.key,
    required this.id,
    required this.endPoint,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DescriptionPageIndicatorState();
}

class _DescriptionPageIndicatorState
    extends ConsumerState<DescriptionPageIndicator> {
  bool loaded = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkAndFetch();
    });
  }

  Future<void> _checkAndFetch() async {
    loaded = false;
    bool checkConnection =
        await CheckInternetConnection().checkInternetConnection();
    ref
        .read(connectivityProvider.notifier)
        .updateConnectionStatus(checkConnection);

    if (checkConnection) {
      await getIndicatorDescriptionData(); // Ensure this method is properly awaiting
    }
  }

  Future<void> getIndicatorDescriptionData() async {
    await ref
        .read(indicatorDescriptionProvider.notifier)
        .getIndicatorDescription(widget.id, widget.endPoint);
  }

  //Function to open image in another screen
  void showFullScreenImage(BuildContext context, ImageProvider imageProvider,
      Uint8List? uint8Listtype) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return FullScreenImageDialog(
            imageProvider: imageProvider,
            imageUrl: '',
            uint8Listtype: uint8Listtype,
          );
        },
        fullscreenDialog: true));
  }

  // Function to decode the Base64 image string
  Uint8List _decodeBase64Image(String? base64String) {
    if (base64String != null && base64String.startsWith('data:image/')) {
      // Split the Base64 string to get only the encoded part
      final base64Data = base64String.split(',').last;
      return base64Decode(base64Data);
    }
    return Uint8List(0); // Return an empty Uint8List if not valid
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ref.watch(connectivityProvider);
    final getIndicatorDescriptionData = ref.watch(indicatorDescriptionProvider);
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: indicatorDetailsText,
        handleBackButton: () {
          Navigator.pop(context);
        },
      ),
      body: !hasConnection
          ? const NoContentWidget(message: noContentScreenText)
          : getIndicatorDescriptionData.isLoading == true
              ? const CommonLoaderGif()
              : RefreshIndicator(
                  onRefresh: _checkAndFetch,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getIndicatorDescriptionData
                                        .indicatorBindingDataModel?.heading ??
                                    "",
                                style: textH4.copyWith(fontSize: 18),
                              ),
                              Divider(color: theme.primaryColorDark),
                              if (getIndicatorDescriptionData
                                      .indicatorBindingDataModel?.bindedData !=
                                  null)
                                _htmlContent(
                                  getIndicatorDescriptionData
                                          .indicatorBindingDataModel
                                          ?.bindedData ??
                                      '',
                                ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _exampleButton(
                          theme,
                          width,
                          getIndicatorDescriptionData
                                  .indicatorBindingDataModel?.attachment ??
                              "",
                          getIndicatorDescriptionData.indicatorBindingDataModel
                                  ?.attachmentDescription ??
                              "",
                          getIndicatorDescriptionData
                                  .indicatorBindingDataModel?.attachmentTitle ??
                              "",
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _htmlContent(String? bindedData) {
    return HtmlWidget(
      onErrorBuilder: (context, element, error) {
        return const Center(child: Text("Something went Wrong"));
      },
      onLoadingBuilder: (context, element, loadingProgress) {
        return const SizedBox.shrink();
      },
      onTapUrl: (url) => true,
      customWidgetBuilder: (element) {
        if (!loaded) {
          setState(() {
            loaded = true;
          });
        }
        if (element.localName == "img") {
          return GestureDetector(
            onTap: element.attributes["src"]!.contains("base64")
                ? () {
                    showFullScreenImage(
                      context,
                      NetworkImage(element.attributes["src"].toString()),
                      _decodeBase64Image(element.attributes["src"].toString()),
                    );
                  }
                : () {
                    showFullScreenImage(
                      context,
                      NetworkImage(element.attributes["src"].toString()),
                      null,
                    );
                  },
            child: element.attributes["src"]!.contains("base64")
                ? Image.memory(
                    _decodeBase64Image(element.attributes["src"].toString()),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    element.attributes["src"]!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      productLandScapeImage,
                      fit: BoxFit.cover,
                    ),
                  ),
          );
        }
        return null;
      },
      bindedData ?? '',
    );
  }

  Widget _exampleButton(theme, double width, String? attachment,
      String? attachmentDescription, String? attachmentTitle) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: theme.primaryColor,
      child: !loaded
          ? const SizedBox.shrink()
          : attachment == null || attachment.trim() == ""
              ? Button(
                  textStyle: TextStyle(color: theme.primaryColor, fontSize: 12),
                  text: 'View Examples',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExampleScreen(
                          id: widget.id,
                          endPoints: getLearningContentExamples,
                        ),
                      ),
                    );
                  },
                  backgroundColor: theme.indicatorColor,
                  textColor: theme.floatingActionButtonTheme.foregroundColor,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width / 2.3,
                      child: Button(
                        textStyle:
                            TextStyle(color: theme.primaryColor, fontSize: 12),
                        text: 'View Examples',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExampleScreen(
                                id: widget.id,
                                endPoints: getLearningContentExamples,
                              ),
                            ),
                          );
                        },
                        backgroundColor: theme.indicatorColor,
                        textColor:
                            theme.floatingActionButtonTheme.foregroundColor,
                      ),
                    ),
                    SizedBox(
                      width: width / 2.2,
                      child: Button(
                        textStyle:
                            TextStyle(color: theme.primaryColor, fontSize: 12),
                        text: 'View Example Videos',
                        onPressed: attachment == ""
                            ? () {}
                            : () {
                                Navigator.pushNamed(
                                    context, youtubeVideoPlayerWidget,
                                    arguments:
                                        ProductDetailsItemApiResponseModel(
                                      attachment: attachment,
                                      description: attachmentDescription ?? "",
                                      title: attachmentTitle,
                                    ));
                              },
                        backgroundColor: theme.indicatorColor,
                        textColor:
                            theme.floatingActionButtonTheme.foregroundColor,
                      ),
                    ),
                  ],
                ),
    );
  }
}
