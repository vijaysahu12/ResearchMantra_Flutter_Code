import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:research_mantra_official/constants/generic_message.dart';
import 'package:research_mantra_official/providers/forms/forms_provider.dart';
import 'package:research_mantra_official/providers/forms/query_category/query_category_provider.dart';
import 'package:research_mantra_official/ui/components/app_bar.dart';
import 'package:research_mantra_official/ui/components/button.dart';
import 'package:research_mantra_official/ui/components/dropdown/dropdown.dart';
import 'package:research_mantra_official/ui/themes/text_styles.dart';
import 'package:research_mantra_official/utils/toast_utils.dart';

class QueryFormPage extends ConsumerStatefulWidget {
  final int? id;
  const QueryFormPage({super.key, required this.id});

  @override
  ConsumerState<QueryFormPage> createState() => _QueryFormPageState();
}

class _QueryFormPageState extends ConsumerState<QueryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _queryController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? _selectedCategory;
  bool isSubmited = false;

  final LayerLink _categoryDropdownLayerLink = LayerLink();
  OverlayEntry? _categoryDropdownOverlayEntry;
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getQueryCategoryProviderProvider.notifier)
          .getQueryCategory(widget.id);
    });
  }

  @override
  void dispose() {
    _queryController.dispose();

    super.dispose();
  }

  Future<void> _getImage() async {
    handleToRemoveKeyboard();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _submitForm(String id, String queryDescription) async {
    if (_formKey.currentState!.validate()) {
      // Show loading if needed
      setState(() {
        isSubmited = true;
      });
      await ref
          .read(getFormsStateNotifierProvider.notifier)
          .addQueryForm(widget.id, id.toString(), queryDescription, _imageFile);

      final formState = ref.read(getFormsStateNotifierProvider);

      if (formState.commonHelperResponseModel!.status) {
        ToastUtils.showToast("Query Raised", "");
        Navigator.pop(context);
      } else if (formState.error) {
        ToastUtils.showToast("Something went wrong", "Please try again");
      }
    }
  }

  //function to remove keyboard
  void handleToRemoveKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _removeCategoryDropdown() {
    _categoryDropdownOverlayEntry?.remove();
    _categoryDropdownOverlayEntry = null;
  }

  OverlayEntry _createCategoryDropdownOverlay() {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final getQueryCategories = ref.watch(getQueryCategoryProviderProvider);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeCategoryDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width - 32,
              child: CompositedTransformFollower(
                link: _categoryDropdownLayerLink,
                showWhenUnlinked: false,
                offset: Offset(0, height * 0.055),
                child: Material(
                  child: getQueryCategories.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: theme.appBarTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: List.generate(
                                getQueryCategories.queryCategory.length,
                                (index) {
                              final category =
                                  getQueryCategories.queryCategory[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: DropdownMenuItemWidget(
                                      value: category.name.toString(),
                                      onSelect: (value) {
                                        setState(() {
                                          _selectedCategory =
                                              category.id.toString();
                                        });
                                        _categoryController.text =
                                            category.name.toString();
                                        _removeCategoryDropdown();
                                        _formKey.currentState?.validate();
                                      },
                                      displayText: category.name,
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: index <
                                            getQueryCategories
                                                    .queryCategory.length -
                                                1
                                        ? Colors.grey // or any visible color
                                        : Colors
                                            .transparent, // <- ensures same layout for last item
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCategoryDropdown() {
    if (_categoryDropdownOverlayEntry == null) {
      _categoryDropdownOverlayEntry = _createCategoryDropdownOverlay();
      Overlay.of(context).insert(_categoryDropdownOverlayEntry!);
    } else {
      _removeCategoryDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = MediaQuery.of(context).size.width * 0.03;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CommonAppBarWithBackButton(
        appBarText: queryFormAppBarText,
        handleBackButton: () => Navigator.pop(context),
      ),
      body: GestureDetector(
        onTap: handleToRemoveKeyboard,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(queryFormCategoryText, fontSize),
                  const SizedBox(height: 8),
                  _buildCategoryDropdown(fontSize, theme),
                  const SizedBox(height: 16),
                  _buildLabel(queryFormDescripitonTitle, fontSize),
                  const SizedBox(height: 8),
                  _buildQueryInput(theme),
                  const SizedBox(height: 16),
                  _buildLabel('Attach Image (Optional)', fontSize),
                  const SizedBox(height: 8),
                  _buildImagePicker(theme, fontSize),
                  const SizedBox(height: 24),
                  _buildSubmitButton(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    );
  }

  Widget _buildCategoryDropdown(double fontSize, ThemeData theme) {
    return CompositedTransformTarget(
      link: _categoryDropdownLayerLink,
      child: GestureDetector(
        onTap: _toggleCategoryDropdown,
        child: AbsorbPointer(
          absorbing: true,
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Ensure vertical centering
            children: [
              Expanded(
                // Ensures the text field expands to take up available space
                child: TextFormField(
                  controller: _categoryController,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 20,
                    ),
                    hintText: 'Select category',
                    contentPadding: EdgeInsets.all(8),
                    hintStyle: TextStyle(
                        fontFamily: fontFamily, fontWeight: FontWeight.w600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: theme.shadowColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: theme.shadowColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: theme.shadowColor),
                    ),
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: theme.primaryColorDark,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) => _selectedCategory == null
                      ? 'Please select a category'
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQueryInput(theme) {
    return TextFormField(
      controller: _queryController,
      onChanged: (value) {
        _formKey.currentState?.validate();
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: 'Type your query here...',
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: theme.shadowColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: theme.shadowColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: theme.shadowColor),
        ),
      ),
      maxLines: 5,
      maxLength: 500, // 👈 Shows the character count and enforces limit
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your query';
        }
        if (value.length > 500) {
          return 'Query cannot exceed more than 500 characters';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker(theme, fontSize) {
    return GestureDetector(
      onTap: _getImage,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          // height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: theme.shadowColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _imageFile != null
              ? Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_imageFile!,
                          width: double.infinity, fit: BoxFit.cover),
                    ),
                    Container(
                      width: 30, // Set a fixed width
                      height: 30, // Set a fixed height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.secondaryHeaderColor,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero, // Remove default padding
                        alignment: Alignment.center, // Center the icon
                        icon: Icon(
                          Icons.close,
                          color: theme.disabledColor,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _imageFile = null),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 40, color: theme.focusColor),
                      SizedBox(height: 8),
                      Text('Tap to add image',
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    ThemeData theme,
  ) {
    return Row(
      children: [
        Expanded(
          child: Button(
            text: 'SUBMIT QUERY',
            onPressed: () {
              _submitForm(_selectedCategory.toString(), _queryController.text);
            },
            backgroundColor: theme.indicatorColor,
            textColor: theme.floatingActionButtonTheme.foregroundColor,
            isLoading: isSubmited,
          ),
        ),
      ],
    );
  }
}
