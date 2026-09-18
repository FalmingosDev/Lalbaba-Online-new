import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';


import '../../../../app/theme/app_sizes.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../model/ticket_providers.dart';
import '../widget/photo_picker_field.dart';
import '../widget/ticket_form_actions.dart';

/// "Create a Ticket" form.
///
/// Purely responsible for collecting input and calling
/// [TicketListController.createTicket] — list/table rendering lives in
/// [TicketListView], and the action buttons live in [TicketFormActions].
class CreateTicketForm extends ConsumerStatefulWidget {
  const CreateTicketForm({super.key});

  @override
  ConsumerState<CreateTicketForm> createState() => _CreateTicketFormState();
}

class _CreateTicketFormState extends ConsumerState<CreateTicketForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  final List<XFile> _photos = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    // Lets the user select multiple photos from the gallery at once.
    final images = await _imagePicker.pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;
    setState(() => _photos.addAll(images));
  }

  Future<void> _pickFromCamera() async {
    // Lets the user take a live photo.
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image == null) return;
    setState(() => _photos.add(image));
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(ticketListProvider.notifier).createTicket(
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            photos: _photos,
          );

      if (!mounted) return;
      Navigator.of(context).pop();
      FeedbackHelper.showSuccess(context, 'Ticket submitted successfully');
    } catch (_) {
      if (!mounted) return;
      FeedbackHelper.showError(context, 'Could not submit the ticket');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.screenPadding,
        right: AppSizes.screenPadding,
        top: AppSizes.spacingLarge,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppSizes.screenPadding,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create a Ticket', style: AppTextStyles.headingSmall),
                  IconButton(
                    onPressed:
                        _isSubmitting ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Text('Subject', style: AppTextStyles.label),
              SizedBox(height: AppSizes.spacingXXSmall),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(hintText: 'Subject'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Subject is required'
                    : null,
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Text(
                'Provide a detailed description',
                style: AppTextStyles.label,
              ),
              SizedBox(height: AppSizes.spacingXXSmall),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Type your reply'),
                minLines: 4,
                maxLines: 6,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              SizedBox(height: AppSizes.spacingLarge),
              PhotoPickerField(
                photos: _photos,
                onPickFromGallery: _pickFromGallery,
                onPickFromCamera: _pickFromCamera,
                onRemove: _removePhoto,
              ),
              SizedBox(height: AppSizes.spacingXLarge),
              TicketFormActions(
                onCancel: () => Navigator.of(context).pop(),
                onSubmit: _submit,
                isSubmitting: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
