import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/widgets/app_app_bar.dart';



import '../widgets/app_string.dart';
import '../widgets/languange_constant.dart';

// ============================================================
// PROFILE DATA
// ============================================================

class ProfileData {
  final String name;
  final String email;
  final String phoneNumber;

  // Existing image URL from API
  final String avatarUrl;

  // New selected image path
  final String? selectedImagePath;

  const ProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.selectedImagePath,
  });
}

// ============================================================
// PROFILE PAGE
// ============================================================

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String avatarUrl;

  final ValueChanged<ProfileData>? onSaved;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.onSaved,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final ImagePicker _imagePicker =
      ImagePicker();

  late final TextEditingController
      _nameController;

  late final TextEditingController
      _emailController;

  bool _isEditing = false;

  late String _savedName;
  late String _savedEmail;
  late String _savedAvatarUrl;

  String? _savedLocalImagePath;
  String? _editingLocalImagePath;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _savedName = widget.name;
    _savedEmail = widget.email;
    _savedAvatarUrl = widget.avatarUrl;

    _nameController =
        TextEditingController(
      text: _savedName,
    );

    _emailController =
        TextEditingController(
      text: _savedEmail,
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  // ============================================================
  // START EDIT
  // ============================================================

  void _startEditing() {
    _nameController.text =
        _savedName;

    _emailController.text =
        _savedEmail;

    _editingLocalImagePath =
        _savedLocalImagePath;

    setState(() {
      _isEditing = true;
    });
  }

  // ============================================================
  // CANCEL EDIT
  // ============================================================

  void _cancelEditing() {
    _nameController.text =
        _savedName;

    _emailController.text =
        _savedEmail;

    setState(() {
      _editingLocalImagePath =
          _savedLocalImagePath;

      _isEditing = false;
    });
  }

  // ============================================================
  // CAMERA / GALLERY OPTIONS
  // Camera icon always visible
  // ============================================================

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder: (
        bottomSheetContext,
      ) {
        return SafeArea(
          child: Container(
            margin:
                const EdgeInsets.all(
              12,
            ),
            padding:
                const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .grey.shade300,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                const Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Colors.black87,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // ==============================================
                // CAMERA
                // ==============================================

                ListTile(
                  leading:
                      Container(
                    width: 42,
                    height: 42,
                    alignment:
                        Alignment.center,
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .primary
                          .withOpacity(
                        0.08,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Icon(
                      Icons
                          .camera_alt_outlined,
                      color:
                          AppColors.primary,
                    ),
                  ),

                  title:
                      const Text(
                    'Camera',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  subtitle:
                      const Text(
                    'Take a new photo',
                  ),

                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );

                    _pickImage(
                      ImageSource.camera,
                    );
                  },
                ),

                // ==============================================
                // GALLERY
                // ==============================================

                ListTile(
                  leading:
                      Container(
                    width: 42,
                    height: 42,
                    alignment:
                        Alignment.center,
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .primary
                          .withOpacity(
                        0.08,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Icon(
                      Icons
                          .photo_library_outlined,
                      color:
                          AppColors.primary,
                    ),
                  ),

                  title:
                      const Text(
                    'Gallery',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  subtitle:
                      const Text(
                    'Choose from gallery',
                  ),

                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );

                    _pickImage(
                      ImageSource.gallery,
                    );
                  },
                ),

                const SizedBox(
                  height: 4,
                ),

                Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 16,
                  ),
                  child: SizedBox(
                    width:
                        double.infinity,
                    child:
                        TextButton(
                      onPressed: () {
                        Navigator.pop(
                          bottomSheetContext,
                        );
                      },
                      child:
                          const Text(
                        'Cancel',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage(
    ImageSource source,
  ) async {
    try {
      final XFile? image =
          await _imagePicker
              .pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
        preferredCameraDevice:
            CameraDevice.rear,
      );

      if (image == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      // ========================================================
      // EDIT MODE
      // Image temporary thakbe
      // Save korle final hobe
      // ========================================================

      if (_isEditing) {
        setState(() {
          _editingLocalImagePath =
              image.path;
        });

        return;
      }

      // ========================================================
      // VIEW MODE
      // Image immediately update hobe
      // ========================================================

      setState(() {
        _savedLocalImagePath =
            image.path;

        _editingLocalImagePath =
            _savedLocalImagePath;
      });

      widget.onSaved?.call(
        ProfileData(
          name:
              _savedName,
          email:
              _savedEmail,
          phoneNumber:
              widget.phoneNumber,
          avatarUrl:
              _savedAvatarUrl,
          selectedImagePath:
              _savedLocalImagePath,
        ),
      );

      if (!mounted) {
        return;
      }

      // ========================================================
      // SUCCESS SNACKBAR FROM FeedbackHelper
      // ========================================================

      FeedbackHelper.showSuccess(
        context,
        'Profile photo updated successfully',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      // ========================================================
      // ERROR SNACKBAR FROM FeedbackHelper
      // ========================================================

      FeedbackHelper.showError(
        context,
        'Unable to select image',
      );
    }
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  void _saveProfile() {
    if (!(_formKey.currentState
            ?.validate() ??
        false)) {
      return;
    }

    final String newName =
        _nameController.text
            .trim();

    final String newEmail =
        _emailController.text
            .trim();

    setState(() {
      _savedName =
          newName;

      _savedEmail =
          newEmail;

      _savedLocalImagePath =
          _editingLocalImagePath;

      _isEditing = false;
    });

    widget.onSaved?.call(
      ProfileData(
        name:
            _savedName,
        email:
            _savedEmail,

        // Phone number change hobe na
        phoneNumber:
            widget.phoneNumber,

        avatarUrl:
            _savedAvatarUrl,

        selectedImagePath:
            _savedLocalImagePath,
      ),
    );

    // ==========================================================
    // SUCCESS SNACKBAR FROM FeedbackHelper
    // ==========================================================

    FeedbackHelper.showSuccess(
      context,
      'Profile updated successfully',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation:
          AppLanguageConstants.instance,

      builder: (
        context,
        child,
      ) {
        return Scaffold(
          backgroundColor:
              const Color(
            0xFFF6F7FB,
          ),

          appBar: AppAppBar(
            title:
                AppStrings.myProfile,
            automaticallyImplyLeading:
                true,
            centerTitle:
                true,
          ),

          body: SafeArea(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                20,
                16,
                30,
              ),

              child: Form(
                key:
                    _formKey,

                child: Column(
                  children: [
                    // ==========================================
                    // PROFILE IMAGE
                    // ==========================================

                    _buildProfileImage(),

                    const SizedBox(
                      height: 20,
                    ),

                    // ==========================================
                    // NAME + EDIT / CLOSE
                    // ==========================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Flexible(
                          child: Text(
                            _isEditing
                                ? _nameController
                                    .text
                                : _savedName,

                            textAlign:
                                TextAlign
                                    .center,

                            style:
                                const TextStyle(
                              fontSize: 21,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color:
                                  Colors
                                      .black87,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        InkWell(
                          onTap: _isEditing
                              ? _cancelEditing
                              : _startEditing,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),

                          child:
                              Container(
                            width: 36,
                            height: 36,

                            alignment:
                                Alignment
                                    .center,

                            decoration:
                                BoxDecoration(
                              color: _isEditing
                                  ? Colors.red
                                      .withOpacity(
                                      0.08,
                                    )
                                  : AppColors
                                      .primary
                                      .withOpacity(
                                      0.10,
                                    ),

                              shape:
                                  BoxShape
                                      .circle,
                            ),

                            child: Icon(
                              _isEditing
                                  ? Icons.close
                                  : Icons
                                      .edit_outlined,

                              size: 18,

                              color: _isEditing
                                  ? Colors.red
                                  : AppColors
                                      .primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      _isEditing
                          ? _emailController
                              .text
                          : _savedEmail,

                      style:
                          TextStyle(
                        fontSize: 14,

                        color: Colors
                            .grey
                            .shade600,
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // ==========================================
                    // DETAILS CARD
                    // ==========================================

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.04,
                            ),

                            blurRadius:
                                12,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child:
                          _isEditing
                              ? _buildEditForm()
                              : _buildViewDetails(),
                    ),

                    // ==========================================
                    // SAVE BUTTON
                    // ==========================================

                    if (_isEditing) ...[
                      const SizedBox(
                        height: 24,
                      ),

                      SizedBox(
                        width:
                            double.infinity,

                        height: 52,

                        child:
                            ElevatedButton(
                          onPressed:
                              _saveProfile,

                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                AppColors
                                    .primary,

                            foregroundColor:
                                AppColors
                                    .white,

                            elevation:
                                0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                          ),

                          child:
                              const Text(
                            'Save Changes',

                            style:
                                TextStyle(
                              fontSize:
                                  15,

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  Widget _buildProfileImage() {
    return Stack(
      clipBehavior:
          Clip.none,

      children: [
        Container(
          width: 110,
          height: 110,

          padding:
              const EdgeInsets.all(
            3,
          ),

          decoration:
              const BoxDecoration(
            shape:
                BoxShape.circle,

            gradient:
                LinearGradient(
              colors: [
                Color(
                  0xFF7FD7C4,
                ),
                Color(
                  0xFFE9A0BE,
                ),
              ],

              begin:
                  Alignment.topLeft,

              end:
                  Alignment.bottomRight,
            ),
          ),

          child: ClipOval(
            child:
                _buildProfileImageContent(),
          ),
        ),

        // ================================================
        // CAMERA ICON
        // Always visible
        // ================================================

        Positioned(
          right: -3,
          bottom: 2,

          child: InkWell(
            onTap:
                _showImageSourceOptions,

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            child: Container(
              width: 38,
              height: 38,

              alignment:
                  Alignment.center,

              decoration:
                  BoxDecoration(
                color:
                    AppColors.primary,

                shape:
                    BoxShape.circle,

                border:
                    Border.all(
                  color:
                      Colors.white,

                  width:
                      3,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors
                        .black
                        .withOpacity(
                      0.12,
                    ),

                    blurRadius:
                        6,

                    offset:
                        const Offset(
                      0,
                      2,
                    ),
                  ),
                ],
              ),

              child: Icon(
                Icons
                    .camera_alt_outlined,

                size:
                    19,

                color:
                    AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE IMAGE CONTENT
  // ============================================================

  Widget _buildProfileImageContent() {
    final String? localImagePath =
        _isEditing
            ? _editingLocalImagePath
            : _savedLocalImagePath;

    // ==========================================================
    // NEW LOCAL IMAGE
    // ==========================================================

    if (localImagePath != null &&
        localImagePath
            .trim()
            .isNotEmpty) {
      return Image.file(
        File(
          localImagePath,
        ),

        width:
            110,

        height:
            110,

        fit:
            BoxFit.cover,

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _networkOrFallbackImage();
        },
      );
    }

    // ==========================================================
    // EXISTING API NETWORK IMAGE
    // ==========================================================

    return _networkOrFallbackImage();
  }

  // ============================================================
  // NETWORK IMAGE
  // ============================================================

  Widget _networkOrFallbackImage() {
    final String imageUrl =
        _savedAvatarUrl.trim();

    if (imageUrl.isEmpty) {
      return _fallbackAvatar();
    }

    return Image.network(
      imageUrl,

      width:
          110,

      height:
          110,

      fit:
          BoxFit.cover,

      loadingBuilder: (
        context,
        child,
        loadingProgress,
      ) {
        if (loadingProgress ==
            null) {
          return child;
        }

        return Container(
          color:
              Colors.white,

          alignment:
              Alignment.center,

          child:
              const SizedBox(
            width:
                24,

            height:
                24,

            child:
                CircularProgressIndicator(
              strokeWidth:
                  2,
            ),
          ),
        );
      },

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return _fallbackAvatar();
      },
    );
  }

  // ============================================================
  // VIEW MODE
  // ============================================================

  Widget _buildViewDetails() {
    return Column(
      children: [
        // ======================================================
        // NAME
        // ======================================================

        _ProfileInfoRow(
          icon:
              Icons.person_outline,

          label:
              AppStrings.fullName,

          value:
              _savedName,
        ),

        const Divider(
          height:
              28,
        ),

        // ======================================================
        // EMAIL
        // ======================================================

        _ProfileInfoRow(
          icon:
              Icons.email_outlined,

          label:
              AppStrings.email,

          value:
              _savedEmail,
        ),

        const Divider(
          height:
              28,
        ),

        // ======================================================
        // PHONE NUMBER
        // ======================================================

        _ProfileInfoRow(
          icon:
              Icons.phone_outlined,

          label:
              AppStrings.phoneNumber,

          value: widget
                  .phoneNumber
                  .trim()
                  .isEmpty
              ? 'Not available'
              : widget
                  .phoneNumber,
        ),
      ],
    );
  }

  // ============================================================
  // EDIT MODE
  // ============================================================

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        // ======================================================
        // NAME
        // ======================================================

        Text(
          AppStrings.fullName,

          style:
              const TextStyle(
            fontSize:
                13,

            fontWeight:
                FontWeight.w600,

            color:
                Colors.black54,
          ),
        ),

        const SizedBox(
          height:
              8,
        ),

        TextFormField(
          controller:
              _nameController,

          textInputAction:
              TextInputAction.next,

          onChanged: (_) {
            setState(() {});
          },

          decoration:
              _inputDecoration(
            icon:
                Icons.person_outline,
          ),

          validator:
              (value) {
            if (value == null ||
                value
                    .trim()
                    .isEmpty) {
              return 'Please enter your name';
            }

            return null;
          },
        ),

        const SizedBox(
          height:
              20,
        ),

        // ======================================================
        // EMAIL
        // ======================================================

        Text(
          AppStrings.email,

          style:
              const TextStyle(
            fontSize:
                13,

            fontWeight:
                FontWeight.w600,

            color:
                Colors.black54,
          ),
        ),

        const SizedBox(
          height:
              8,
        ),

        TextFormField(
          controller:
              _emailController,

          keyboardType:
              TextInputType.emailAddress,

          textInputAction:
              TextInputAction.done,

          onChanged: (_) {
            setState(() {});
          },

          decoration:
              _inputDecoration(
            icon:
                Icons.email_outlined,
          ),

          validator:
              (value) {
            final String email =
                value?.trim() ?? '';

            if (email.isEmpty) {
              return 'Please enter your email';
            }

            if (!email.contains(
              '@',
            )) {
              return 'Enter a valid email address';
            }

            return null;
          },
        ),

        const SizedBox(
          height:
              20,
        ),

        // ======================================================
        // PHONE NUMBER
        // ======================================================

        Text(
          AppStrings.phoneNumber,

          style:
              const TextStyle(
            fontSize:
                13,

            fontWeight:
                FontWeight.w600,

            color:
                Colors.black54,
          ),
        ),

        const SizedBox(
          height:
              8,
        ),

        TextFormField(
          initialValue: widget
                  .phoneNumber
                  .trim()
                  .isEmpty
              ? 'Not available'
              : widget
                  .phoneNumber,

          readOnly:
              true,

          decoration:
              _inputDecoration(
            icon:
                Icons.phone_outlined,

            suffixIcon:
                Icons.lock_outline,

            fillColor:
                const Color(
              0xFFF3F3F5,
            ),
          ),
        ),

        const SizedBox(
          height:
              8,
        ),

        Row(
          children: [
            Icon(
              Icons.lock_outline,

              size:
                  13,

              color:
                  Colors.grey
                      .shade500,
            ),

            const SizedBox(
              width:
                  5,
            ),

            Expanded(
              child:
                  Text(
                'Phone number cannot be edited.',

                style:
                    TextStyle(
                  fontSize:
                      11.5,

                  color:
                      Colors.grey
                          .shade600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required IconData icon,
    IconData? suffixIcon,
    Color? fillColor,
  }) {
    return InputDecoration(
      prefixIcon:
          Icon(
        icon,

        size:
            20,
      ),

      suffixIcon:
          suffixIcon != null
              ? Icon(
                  suffixIcon,

                  size:
                      18,
                )
              : null,

      filled:
          true,

      fillColor:
          fillColor ??
              const Color(
                0xFFF8F8FA,
              ),

      contentPadding:
          const EdgeInsets
              .symmetric(
        horizontal:
            14,

        vertical:
            14,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),

        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),

        borderSide:
            BorderSide(
          color:
              Colors.grey
                  .shade200,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),

        borderSide:
            BorderSide(
          color:
              AppColors.primary,

          width:
              1.2,
        ),
      ),
    );
  }

  // ============================================================
  // FALLBACK AVATAR
  // ============================================================

  Widget _fallbackAvatar() {
    return Container(
      color:
          Colors.white,

      alignment:
          Alignment.center,

      child:
          Icon(
        Icons.person,

        size:
            48,

        color:
            Colors.grey
                .shade400,
      ),
    );
  }
}

// ============================================================
// PROFILE INFO ROW
// ============================================================

class _ProfileInfoRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          width:
              42,

          height:
              42,

          alignment:
              Alignment.center,

          decoration:
              BoxDecoration(
            color:
                AppColors.primary
                    .withOpacity(
              0.08,
            ),

            borderRadius:
                BorderRadius
                    .circular(
              11,
            ),
          ),

          child:
              Icon(
            icon,

            size:
                20,

            color:
                AppColors.primary,
          ),
        ),

        const SizedBox(
          width:
              14,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                label,

                style:
                    TextStyle(
                  fontSize:
                      12,

                  color:
                      Colors.grey
                          .shade600,
                ),
              ),

              const SizedBox(
                height:
                    4,
              ),

              Text(
                value,

                style:
                    const TextStyle(
                  fontSize:
                      15,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}