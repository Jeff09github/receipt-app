import 'package:flutter/material.dart';

import '../../../shared/classes/classes.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    Key? key,
    required this.profile,
    required this.onPressed,
  }) : super(key: key);

  final Profile profile;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
      // child: Dismissible(
      //   key: Key(profile.id),
      //   background: Container(
      //     color: Colors.red,
      //     alignment: Alignment.center,
      //     child: const Text(
      //       'DELETE',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      //   onDismissed: (dismissDirection) {
      //     context
      //         .read<ProfilesOverviewBloc>()
      //         .add(DeleteProfile(profile: profile));
      //   },
      child: ListTile(
        leading: const Icon(
          Icons.person,
          size: 50.0,
        ),
        title: Text(profile.customerName),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Speed: ${profile.speed} Mbps'),
            Text('Price: ${profile.price}'),
          ],
        ),
        trailing: TextButton.icon(
          // onPressed: () {
          //   GoRouter.of(context).push('/${profile.id}/0');
          // },
          onPressed: onPressed,
          icon: const Icon(Icons.view_agenda_outlined),
          label: const Text('View'),
        ),
        isThreeLine: true,
      ),
      // ),
    );
  }
}
