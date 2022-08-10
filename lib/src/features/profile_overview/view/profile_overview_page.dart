import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/repository/firestore_database_repository.dart';
import '../../payments/bloc/payments_bloc.dart';
import '../../payments/payments.dart';
import '../../profile_details/bloc/profile_details_bloc.dart';
import '../../profile_details/profile_details.dart';
import '../cubit/profile_overview_cubit.dart';

class ProfileOverviewPage extends StatelessWidget {
  const ProfileOverviewPage({Key? key, required this.id, required this.index})
      : super(key: key);

  final String id;
  final int index;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProfileOverviewCubit(index: index, profileId: id),
        ),
        BlocProvider(
          create: (context) => ProfileDetailsBloc(
            firestoreDatabaseRepository:
                context.read<FirestoreDatabaseRepository>(),
            customerId: id,
          )..add(const ProfileStreamSubscriptionRequest()),
        ),
        BlocProvider(
          create: (context) => PaymentsBloc(
            firestoreDatabaseRepository:
                context.read<FirestoreDatabaseRepository>(),
            customerId: id,
          )..add(const PaymentsStreamSubscriptionRequest()),
        ),
      ],
      child: const ProfileOverviewView(),
    );
  }
}

class ProfileOverviewView extends StatefulWidget {
  const ProfileOverviewView({Key? key}) : super(key: key);

  @override
  State<ProfileOverviewView> createState() => _ProfileOverviewViewState();
}

class _ProfileOverviewViewState extends State<ProfileOverviewView>
    with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: context.read<ProfileOverviewCubit>().index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = context.read<ProfileOverviewCubit>().state.profileId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(tabController.index == 0 ? 'Details' : 'Payments'),
        bottom: TabBar(
          controller: tabController,
          onTap: (index) {
            if (tabController.indexIsChanging) {
              setState(() {
                tabController.index = index;
              });
              GoRouter.of(context).go('/$id/$index');
            }
          },
          tabs: const [
            Icon(Icons.person),
            Icon(Icons.payment),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          ProfileDetailsPage(),
          PaymentsPage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
