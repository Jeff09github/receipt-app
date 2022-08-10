import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_app/src/features/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:receipt_app/src/shared/providers/validator.dart';
import 'package:receipt_app/src/shared/repository/firestore_database_repository.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/widgets/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key, this.profile}) : super(key: key);

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        initialProfile: profile,
        firestoreDatabaseRepository:
            context.read<FirestoreDatabaseRepository>(),
      ),
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listenWhen: ((previous, current) =>
            previous.status != current.status &&
            current.status == EditProfileStatus.success),
        listener: (context, state) {
          GoRouter.of(context).pop();
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: EditProfileView(),
        ),
      ),
    );
  }
}

class EditProfileView extends StatelessWidget with Validator {
  EditProfileView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isNewProfile =
        context.select((EditProfileBloc bloc) => bloc.isNewProfile);

    final status = context.select((EditProfileBloc bloc) => bloc.state.status);
    final profile = context.read<EditProfileBloc>().state.profile;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: isNewProfile
            ? const Text('Create New Profile')
            : const Text('Update Profile'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  labelText: 'Customer Name',
                  initialValue: profile?.customerName ?? '',
                  textInputType: TextInputType.name,
                  validate: validateString,
                  onChanged: (value) {
                    context
                        .read<EditProfileBloc>()
                        .add(CustomerChanged(customer: value));
                  },
                  textInputFormatters: [
                    FilteringTextInputFormatter(
                        RegExp(r'[!@#<>/?":_`~;[\]\\|=+)(*&^%0-9-]'),
                        allow: false)
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                CustomTextFormField(
                  labelText: 'Speed',
                  initialValue: profile?.speed.toString() ?? '',
                  textInputType: TextInputType.number,
                  validate: validateString,
                  onChanged: (value) {
                    context
                        .read<EditProfileBloc>()
                        .add(SpeedChanged(speed: value));
                  },
                  textInputFormatters: [
                    FilteringTextInputFormatter(RegExp(r'^[0-9]+$'),
                        allow: true)
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                CustomTextFormField(
                  labelText: 'Price',
                  initialValue: profile?.price.toString() ?? '',
                  textInputType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validate: validateString,
                  onChanged: (value) {
                    context
                        .read<EditProfileBloc>()
                        .add(AmountChanged(amount: value));
                  },
                  textInputFormatters: [
                    FilteringTextInputFormatter(RegExp(r'^[0-9]+$'),
                        allow: true)
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: status == EditProfileStatus.loading
            ? null
            : () {
                final isValidated = _formKey.currentState!.validate();
                if (isValidated) {
                  context.read<EditProfileBloc>().add(Submitted());
                }
              },
        child: status == EditProfileStatus.loading
            ? const CircularProgressIndicator()
            : const Icon(Icons.check),
      ),
    );
  }
}
