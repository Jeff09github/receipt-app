import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_app/src/features/profiles_overview/bloc/profiles_overview_bloc.dart';
import 'package:receipt_app/src/features/profiles_overview/view/profile_list_tile.dart';
import 'package:receipt_app/src/shared/providers/validator.dart';
import 'package:receipt_app/src/shared/repository/firestore_database_repository.dart';
import 'package:receipt_app/src/shared/widgets/widgets.dart';

class ProfilesOverviewPage extends StatelessWidget {
  const ProfilesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilesOverviewBloc(
          firestoreDatabaseRepository:
              context.read<FirestoreDatabaseRepository>())
        ..add(
          const StreamSubscriptionRequest(),
        ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: const ProfilesOverviewView(),
      ),
    );
  }
}

class ProfilesOverviewView extends StatelessWidget with Validator {
  const ProfilesOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              labelText: 'Search',
              validate: validateString,
              onChanged: (value) {
                context
                    .read<ProfilesOverviewBloc>()
                    .add(StreamSubscriptionRequest(filter: value));
              },
              textInputType: TextInputType.name,
              textInputFormatters: [
                FilteringTextInputFormatter(
                    RegExp(r'[!@#<>/?":_`~;[\]\\|=+)(*&^%0-9-]'),
                    allow: false),
              ],
            ),
            Expanded(
              child: BlocBuilder<ProfilesOverviewBloc, ProfilesOverviewState>(
                builder: (context, state) {
                  if (state.status == ProfilesOverviewStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.status == ProfilesOverviewStatus.success) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.profiles.length,
                      itemBuilder: (context, index) {
                        return ProfileListTile(
                          profile: state.profiles[index],
                          onPressed: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            GoRouter.of(context)
                                .push('/${state.profiles[index].id}/0');
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Check your internet connection'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
