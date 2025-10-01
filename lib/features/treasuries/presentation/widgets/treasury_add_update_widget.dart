import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpletreasury/core/utils/snackbar_message.dart';
import 'package:simpletreasury/core/widgets/loading_widget.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuries_add_edit_delete/treasuries_add_edit_delete_bloc.dart';

class TreasuryDialog extends StatefulWidget {
  final Treasury? treasury;
  final bool isUpdateTreasury;
  final Function(String) onConfirm;

  const TreasuryDialog({
    super.key,
    this.treasury,
    required this.isUpdateTreasury,
    required this.onConfirm,
  });

  @override
  State<TreasuryDialog> createState() => _TreasuryDialogState();
}

class _TreasuryDialogState extends State<TreasuryDialog> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Pre-fill the title if we're updating an existing treasury
    if (widget.treasury != null) {
      _titleController.text = widget.treasury!.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child:
              BlocConsumer<
                TreasuriesAddEditDeleteBloc,
                TreasuriesAddEditDeleteState
              >(
                listener: (context, state) {
                  if (state is MessageAddEditDeleteTreasuryState) {
                    SnackbarMessage().showSuccessSnackBar(
                      message: state.message,
                      context: context,
                    );
                    Navigator.of(context).pop();
                  } else if (state is ErrorAddEditDeleteTreasuryState) {
                    SnackbarMessage().showErrorSnackBar(
                      message: state.message,
                      context: context,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoadingAddEditDeleteTreasuryState) {
                    return LoadingWidget();
                  }
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dialog Title - Subtitle style
                        Text(
                          widget.isUpdateTreasury
                              ? 'Edit Treasury'
                              : 'Add New Treasury',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333), // Charcoal
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // Treasury Title Field
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Treasury Title',
                            labelStyle: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF708090), // Slate Gray
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF708090), // Slate Gray
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF1A2B4C), // Navy Blue
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF708090), // Slate Gray
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF333333), // Charcoal
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a treasury title';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24.0),

                        // Buttons Row
                        Row(
                          children: [
                            // Cancel Button - Secondary
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(
                                          0xFF708090,
                                        ), // Slate Gray
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(
                                            0xFF708090,
                                          ), // Slate Gray
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12.0),

                            // Confirm Button - Primary
                            Expanded(
                              child: Material(
                                color: const Color(0xFF1A2B4C), // Navy Blue
                                borderRadius: BorderRadius.circular(8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      widget.onConfirm(
                                        _titleController.text.trim(),
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.isUpdateTreasury
                                            ? 'Update'
                                            : 'Create',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
