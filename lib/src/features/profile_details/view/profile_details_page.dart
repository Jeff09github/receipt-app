import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_app/src/features/profile_details/bloc/profile_details_bloc.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProfileDetailsView();
  }
}

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
      builder: (context, state) {
        if (state.status == ProfileDetailsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == ProfileDetailsStatus.success) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Client Name: ${state.profile!.customerName}'),
                  Text('Speed: ${state.profile!.speed.toString()} Mbps'),
                  Text('Price: ${state.profile!.price.toString()}'),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                GoRouter.of(context).push(
                  '/${state.profile!.id}/0/edit',
                  extra: state.profile,
                );
              },
              child: const Icon(
                Icons.edit,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
