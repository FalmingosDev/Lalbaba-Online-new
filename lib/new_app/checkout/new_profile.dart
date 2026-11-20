import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';

// =============================================================
// NEW PROFILE DATA
// =============================================================

class NewProfileData {
  final String name;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String? selectedImagePath;

  const NewProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.selectedImagePath,
  });
}

// =============================================================
// PROFILE PAGE STYLE
// =============================================================

class _ProfileStyle {
  _ProfileStyle._();

  static const double pagePadding = 16;
  static const double avatarSize = 110;
  static const double cameraSize = 38;
  static const double editIconSize = 36;
  static const double cardRadius = 18;
  static const double inputRadius = 12;
  static const double buttonRadius = 14;
  static const double buttonHeight = 52;
  static const double infoIconSize = 42;
}

// =============================================================
// NEW PROFILE PAGE
// =============================================================

class NewProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String? selectedImagePath;

  final ValueChanged<NewProfileData>? onSaved;

  const NewProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.selectedImagePath,
    this.onSaved,
  });

  @override
  State<NewProfilePage> createState() =>
      _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {

  // ===========================================================
  // VARIABLES
  // ===========================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _isEditing = false;
  bool _isPickingImage = false;

  late String _savedName;
  late String _savedEmail;
  late String _savedAvatarUrl;

  String? _savedLocalImagePath;
  String? _editingLocalImagePath;

  String get _phoneNumber {
    return widget.phoneNumber.trim().isEmpty
        ? 'Not available'
        : widget.phoneNumber;
  }

  // ===========================================================
  // INIT STATE
  // ===========================================================

  @override
  void initState() {
    super.initState();

    _savedName = widget.name;
    _savedEmail = widget.email;
    _savedAvatarUrl = widget.avatarUrl;

    _savedLocalImagePath = widget.selectedImagePath;
    _editingLocalImagePath = _savedLocalImagePath;

    _nameController = TextEditingController(
      text: _savedName,
    );

    _emailController = TextEditingController(
      text: _savedEmail,
    );
  }

  // ===========================================================
  // DISPOSE
  // ===========================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  // ===========================================================
  // LOCAL SNACKBAR
  // ===========================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError
              ? HomeColors.error
              : HomeColors.success,

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline
                    : Icons.check_circle_outline,

                color: HomeColors.white,
                size: 22,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,

                  style: HomeTextStyles.body.copyWith(
                    color: HomeColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ===========================================================
  // START EDITING
  // ===========================================================

  void _startEditing() {
    _nameController.text = _savedName;
    _emailController.text = _savedEmail;

    _editingLocalImagePath = _savedLocalImagePath;

    setState(() {
      _isEditing = true;
    });
  }

  // ===========================================================
  // CANCEL EDITING
  // ===========================================================

  void _cancelEditing() {
    FocusScope.of(context).unfocus();

    _nameController.text = _savedName;
    _emailController.text = _savedEmail;

    setState(() {
      _editingLocalImagePath = _savedLocalImagePath;
      _isEditing = false;
    });
  }

  // ===========================================================
  // NOTIFY ACCOUNT PAGE
  // ===========================================================

  void _notifyProfileUpdated() {
    widget.onSaved?.call(
      NewProfileData(
        name: _savedName,
        email: _savedEmail,
        phoneNumber: widget.phoneNumber,
        avatarUrl: _savedAvatarUrl,
        selectedImagePath: _savedLocalImagePath,
      ),
    );
  }

  // ===========================================================
  // CAMERA AND GALLERY BOTTOM SHEET
  // ===========================================================

  void _showImageSourceOptions() {
    if (_isPickingImage) return;

    showModalBottomSheet<void>(
      context: context,

      backgroundColor:
          HomeColors.surface.withValues(alpha: 0),

      builder: (bottomSheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),

            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: HomeColors.surface,

              borderRadius: BorderRadius.circular(22),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                // BOTTOM SHEET HANDLE

                Container(
                  width: 42,
                  height: 4,

                  decoration: BoxDecoration(
                    color: HomeColors.border,

                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 16),

                // TITLE

                Text(
                  'Change Profile Photo',

                  style: HomeTextStyles
                      .summaryTotalLabel
                      .copyWith(
                        color: HomeColors.textPrimary,
                      ),
                ),

                const SizedBox(height: 10),

                // CAMERA OPTION

                _ImageSourceTile(
                  icon: Icons.camera_alt_outlined,

                  title: 'Camera',

                  subtitle: 'Take a new photo',

                  onTap: () {
                    Navigator.of(
                      bottomSheetContext,
                    ).pop();

                    _pickImage(ImageSource.camera);
                  },
                ),

                // GALLERY OPTION

                _ImageSourceTile(
                  icon: Icons.photo_library_outlined,

                  title: 'Gallery',

                  subtitle: 'Choose from gallery',

                  onTap: () {
                    Navigator.of(
                      bottomSheetContext,
                    ).pop();

                    _pickImage(ImageSource.gallery);
                  },
                ),

                const SizedBox(height: 4),

                // CANCEL BUTTON

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: SizedBox(
                    width: double.infinity,

                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          bottomSheetContext,
                        ).pop();
                      },

                      style: TextButton.styleFrom(
                        foregroundColor:
                            HomeColors.secondary,

                        textStyle:
                            HomeTextStyles.button,
                      ),

                      child: const Text('Cancel'),
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

  // ===========================================================
  // PICK IMAGE
  // ===========================================================

  Future<void> _pickImage(
    ImageSource source,
  ) async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? image =
          await _imagePicker.pickImage(
        source: source,

        imageQuality: 85,

        maxWidth: 1200,
        maxHeight: 1200,

        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null || !mounted) return;

      // EDIT MODE

      if (_isEditing) {
        setState(() {
          _editingLocalImagePath = image.path;
        });

        return;
      }

      // VIEW MODE

      setState(() {
        _savedLocalImagePath = image.path;

        _editingLocalImagePath = image.path;
      });

      _notifyProfileUpdated();

      _showMessage(
        'Profile photo updated successfully',
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Unable to select image',
        isError: true,
      );

      debugPrint('Profile Image Error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  // ===========================================================
  // SAVE PROFILE
  // ===========================================================

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final String newName =
        _nameController.text.trim();

    final String newEmail =
        _emailController.text.trim();

    setState(() {
      _savedName = newName;

      _savedEmail = newEmail;

      _savedLocalImagePath =
          _editingLocalImagePath;

      _isEditing = false;
    });

    _notifyProfileUpdated();

    _showMessage(
      'Profile updated successfully',
    );
  }

  // ===========================================================
  // MAIN BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      // =======================================================
      // COMMON APPBAR FROM CONSTANTAPPBAR.DART
      // =======================================================

      appBar: const CommonAppBar(
        title: 'My Profile',

        automaticallyImplyLeading: false,

        showBackButton: true,

        centerTitle: true,

        backgroundColor: HomeColors.secondary,

        titleColor: HomeColors.white,

        iconColor: HomeColors.white,
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SafeArea(
        top: false,

        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            _ProfileStyle.pagePadding,
            20,
            _ProfileStyle.pagePadding,
            30,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                // =============================================
                // PROFILE IMAGE
                // =============================================

                _buildProfileImage(),

                const SizedBox(height: 20),

                // =============================================
                // PROFILE NAME AND EDIT BUTTON
                // =============================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Flexible(
                      child: Text(
                        _isEditing
                            ? _nameController.text
                            : _savedName,

                        textAlign: TextAlign.center,

                        style: HomeTextStyles.pageTitle
                            .copyWith(
                              color:
                                  HomeColors.textPrimary,
                            ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // EDIT / CANCEL ICON

                    Material(
                      color: HomeColors.secondaryLight,

                      shape: const CircleBorder(),

                      child: InkWell(
                        onTap: _isPickingImage
                            ? null
                            : _isEditing
                                ? _cancelEditing
                                : _startEditing,

                        customBorder:
                            const CircleBorder(),

                        child: SizedBox(
                          width:
                              _ProfileStyle.editIconSize,

                          height:
                              _ProfileStyle.editIconSize,

                          child: Center(
                            child: Icon(
                              _isEditing
                                  ? Icons.close
                                  : Icons.edit_outlined,

                              size: 18,

                              color: HomeColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // =============================================
                // PROFILE EMAIL
                // =============================================

                Text(
                  _isEditing
                      ? _emailController.text
                      : _savedEmail,

                  textAlign: TextAlign.center,

                  style: HomeTextStyles.body.copyWith(
                    color: HomeColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                // =============================================
                // PROFILE DETAILS CARD
                // =============================================

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: HomeColors.surface,

                    borderRadius: BorderRadius.circular(
                      _ProfileStyle.cardRadius,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: HomeColors.black.withValues(
                          alpha: 0.04,
                        ),

                        blurRadius: 12,

                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: _isEditing
                      ? _buildEditForm()
                      : _buildViewDetails(),
                ),

                // =============================================
                // SAVE CHANGES BUTTON
                // =============================================

                if (_isEditing) ...[
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,

                    height: _ProfileStyle.buttonHeight,

                    child: ElevatedButton(
                      onPressed: _isPickingImage
                          ? null
                          : _saveProfile,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            HomeColors.secondary,

                        foregroundColor:
                            HomeColors.white,

                        disabledBackgroundColor:
                            HomeColors.disabledBackground,

                        disabledForegroundColor:
                            HomeColors.disabled,

                        textStyle: HomeTextStyles.button,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            _ProfileStyle.buttonRadius,
                          ),
                        ),
                      ),

                      child: const Text(
                        'Save Changes',
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
  }

  // ===========================================================
  // PROFILE IMAGE WITH CAMERA ICON
  // ===========================================================

  Widget _buildProfileImage() {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        Container(
          width: _ProfileStyle.avatarSize,

          height: _ProfileStyle.avatarSize,

          padding: const EdgeInsets.all(3),

          decoration: const BoxDecoration(
            shape: BoxShape.circle,

            gradient: LinearGradient(
              colors: [
                HomeColors.secondary,
                HomeColors.secondaryLight,
              ],

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,
            ),
          ),

          child: ClipOval(
            child: _buildProfileImageContent(),
          ),
        ),

        // =====================================================
        // CAMERA ICON
        // =====================================================

        Positioned(
          right: -3,

          bottom: 2,

          child: Material(
            color: HomeColors.secondary,

            shape: const CircleBorder(),

            child: InkWell(
              onTap: _isPickingImage
                  ? null
                  : _showImageSourceOptions,

              customBorder: const CircleBorder(),

              child: Container(
                width: _ProfileStyle.cameraSize,

                height: _ProfileStyle.cameraSize,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: HomeColors.secondary,

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: HomeColors.white,

                    width: 3,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: HomeColors.black.withValues(
                        alpha: 0.12,
                      ),

                      blurRadius: 6,

                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: _isPickingImage
                    ? const SizedBox(
                        width: 15,

                        height: 15,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,

                          color: HomeColors.white,
                        ),
                      )
                    : const Icon(
                        Icons.camera_alt_outlined,

                        size: 19,

                        color: HomeColors.white,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // PROFILE IMAGE CONTENT
  // ===========================================================

  Widget _buildProfileImageContent() {
    final String? localImagePath = _isEditing
        ? _editingLocalImagePath
        : _savedLocalImagePath;

    // LOCAL SELECTED IMAGE

    if (localImagePath != null &&
        localImagePath.trim().isNotEmpty) {
      return Image.file(
        File(localImagePath),

        width: _ProfileStyle.avatarSize,

        height: _ProfileStyle.avatarSize,

        fit: BoxFit.cover,

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _networkOrFallbackImage();
        },
      );
    }

    return _networkOrFallbackImage();
  }

  // ===========================================================
  // NETWORK OR ASSET IMAGE
  // ===========================================================

  Widget _networkOrFallbackImage() {
    final String imageUrl = _savedAvatarUrl.trim();

    if (imageUrl.isEmpty) {
      return _fallbackAvatar();
    }

    // NETWORK IMAGE

    if (imageUrl.startsWith('https://') ||
        imageUrl.startsWith('http://')) {
      return Image.network(
        imageUrl,

        width: _ProfileStyle.avatarSize,

        height: _ProfileStyle.avatarSize,

        fit: BoxFit.cover,

        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return Container(
            color: HomeColors.surface,

            alignment: Alignment.center,

            child: const SizedBox(
              width: 24,

              height: 24,

              child: CircularProgressIndicator(
                strokeWidth: 2,

                color: HomeColors.secondary,
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

    // ASSET IMAGE

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,

        fit: BoxFit.cover,

        errorBuilder: (_, __, ___) {
          return _fallbackAvatar();
        },
      );
    }

    // LOCAL FILE IMAGE

    return Image.file(
      File(imageUrl),

      fit: BoxFit.cover,

      errorBuilder: (_, __, ___) {
        return _fallbackAvatar();
      },
    );
  }

  // ===========================================================
  // FALLBACK AVATAR
  // ===========================================================

  Widget _fallbackAvatar() {
    return Container(
      color: HomeColors.secondaryLight,

      alignment: Alignment.center,

      child: const Icon(
        Icons.person,

        size: 48,

        color: HomeColors.secondary,
      ),
    );
  }

  // ===========================================================
  // VIEW PROFILE DETAILS
  // ===========================================================

  Widget _buildViewDetails() {
    return Column(
      children: [
        // FULL NAME

        _NewProfileInfoRow(
          icon: Icons.person_outline,

          label: 'Full Name',

          value: _savedName,
        ),

        const Divider(
          height: 28,

          color: HomeColors.divider,
        ),

        // EMAIL

        _NewProfileInfoRow(
          icon: Icons.email_outlined,

          label: 'Email',

          value: _savedEmail,
        ),

        const Divider(
          height: 28,

          color: HomeColors.divider,
        ),

        // PHONE NUMBER

        _NewProfileInfoRow(
          icon: Icons.phone_outlined,

          label: 'Phone Number',

          value: _phoneNumber,
        ),
      ],
    );
  }

  // ===========================================================
  // EDIT PROFILE FORM
  // ===========================================================

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // =====================================================
        // FULL NAME
        // =====================================================

        _buildFieldLabel('Full Name'),

        const SizedBox(height: 8),

        TextFormField(
          controller: _nameController,

          cursorColor: HomeColors.secondary,

          textInputAction: TextInputAction.next,

          textCapitalization: TextCapitalization.words,

          style: HomeTextStyles.body.copyWith(
            color: HomeColors.textPrimary,
          ),

          onChanged: (_) {
            setState(() {});
          },

          decoration: _inputDecoration(
            icon: Icons.person_outline,
          ),

          validator: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return 'Please enter your name';
            }

            return null;
          },
        ),

        const SizedBox(height: 20),

        // =====================================================
        // EMAIL
        // =====================================================

        _buildFieldLabel('Email'),

        const SizedBox(height: 8),

        TextFormField(
          controller: _emailController,

          cursorColor: HomeColors.secondary,

          keyboardType: TextInputType.emailAddress,

          textInputAction: TextInputAction.done,

          style: HomeTextStyles.body.copyWith(
            color: HomeColors.textPrimary,
          ),

          onChanged: (_) {
            setState(() {});
          },

          decoration: _inputDecoration(
            icon: Icons.email_outlined,
          ),

          validator: (value) {
            final String email = value?.trim() ?? '';

            if (email.isEmpty) {
              return 'Please enter your email';
            }

            final bool validEmail = RegExp(
              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            ).hasMatch(email);

            if (!validEmail) {
              return 'Enter a valid email address';
            }

            return null;
          },
        ),

        const SizedBox(height: 20),

        // =====================================================
        // PHONE NUMBER
        // =====================================================

        _buildFieldLabel('Phone Number'),

        const SizedBox(height: 8),

        TextFormField(
          initialValue: _phoneNumber,

          readOnly: true,

          showCursor: false,

          enableInteractiveSelection: false,

          style: HomeTextStyles.body.copyWith(
            color: HomeColors.textSecondary,
          ),

          decoration: _inputDecoration(
            icon: Icons.phone_outlined,

            suffixIcon: Icons.lock_outline,

            fillColor: HomeColors.disabledBackground,
          ),
        ),

        const SizedBox(height: 8),

        // PHONE NUMBER NOTE

        Row(
          children: [
            const Icon(
              Icons.lock_outline,

              size: 13,

              color: HomeColors.textHint,
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                'Phone number cannot be edited.',

                style: HomeTextStyles.caption.copyWith(
                  color: HomeColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================
  // FIELD LABEL
  // ===========================================================

  Widget _buildFieldLabel(String label) {
    return Text(
      label,

      style: HomeTextStyles.bodySmall.copyWith(
        fontWeight: HomeTextStyles.semiBold,

        color: HomeColors.textSecondary,
      ),
    );
  }

  // ===========================================================
  // INPUT DECORATION
  // ===========================================================

  InputDecoration _inputDecoration({
    required IconData icon,
    IconData? suffixIcon,
    Color? fillColor,
  }) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,

        size: 20,

        color: HomeColors.secondary,
      ),

      suffixIcon: suffixIcon != null
          ? Icon(
              suffixIcon,

              size: 18,

              color: HomeColors.textHint,
            )
          : null,

      filled: true,

      fillColor: fillColor ?? HomeColors.background,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,

        vertical: 14,
      ),

      errorStyle: HomeTextStyles.caption.copyWith(
        color: HomeColors.error,
      ),

      // DEFAULT BORDER

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          _ProfileStyle.inputRadius,
        ),

        borderSide: BorderSide.none,
      ),

      // ENABLED BORDER

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          _ProfileStyle.inputRadius,
        ),

        borderSide: const BorderSide(
          color: HomeColors.border,
        ),
      ),

      // FOCUSED BORDER

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          _ProfileStyle.inputRadius,
        ),

        borderSide: const BorderSide(
          color: HomeColors.secondary,

          width: 1.2,
        ),
      ),

      // ERROR BORDER

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          _ProfileStyle.inputRadius,
        ),

        borderSide: const BorderSide(
          color: HomeColors.error,
        ),
      ),

      // FOCUSED ERROR BORDER

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          _ProfileStyle.inputRadius,
        ),

        borderSide: const BorderSide(
          color: HomeColors.error,

          width: 1.2,
        ),
      ),
    );
  }
}

// =============================================================
// IMAGE SOURCE TILE
// =============================================================

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _ImageSourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: _ProfileStyle.infoIconSize,

        height: _ProfileStyle.infoIconSize,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: HomeColors.secondaryLight,

          borderRadius: BorderRadius.circular(12),
        ),

        child: Icon(
          icon,

          color: HomeColors.secondary,
        ),
      ),

      title: Text(
        title,

        style: HomeTextStyles.bodyEmphasis.copyWith(
          color: HomeColors.textPrimary,
        ),
      ),

      subtitle: Text(
        subtitle,

        style: HomeTextStyles.bodySmall.copyWith(
          color: HomeColors.textSecondary,
        ),
      ),

      onTap: onTap,
    );
  }
}

// =============================================================
// PROFILE INFO ROW
// =============================================================

class _NewProfileInfoRow extends StatelessWidget {
  final IconData icon;

  final String label;

  final String value;

  const _NewProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // INFO ICON

        Container(
          width: _ProfileStyle.infoIconSize,

          height: _ProfileStyle.infoIconSize,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: HomeColors.secondaryLight,

            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(
            icon,

            size: 20,

            color: HomeColors.secondary,
          ),
        ),

        const SizedBox(width: 14),

        // INFO TEXT

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                label,

                style: HomeTextStyles.caption.copyWith(
                  color: HomeColors.textSecondary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,

                style: HomeTextStyles.productTitle
                    .copyWith(
                      color: HomeColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}