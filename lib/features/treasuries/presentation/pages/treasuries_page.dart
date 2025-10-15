import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpletreasury/core/widgets/loading_widget.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuriesGets/treasuries_bloc.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuries_add_edit_delete/treasuries_add_edit_delete_bloc.dart';
import 'package:simpletreasury/features/treasuries/presentation/widgets/message_display_widget.dart';
import 'package:simpletreasury/features/treasuries/presentation/widgets/treasuries_list_widget.dart';
import 'package:simpletreasury/features/treasuries/presentation/widgets/treasury_add_update_widget.dart';

class TreasuriesPage extends StatelessWidget {
  const TreasuriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(context),
    );
  }

  AppBar _buildAppbar() => AppBar(title: Text("treasuries"));

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<TreasuriesBloc, TreasuriesState>(
        builder: (context, state) {
          if (state is LoadingTreasuriesWithTransactionsState) {
            return LoadingWidget();
          } else if (state is LoadedTreasuriesWithTransactionsState) {
            return RefreshIndicator(
              child: TreasuriesListWidget(
                treasuriesWithTransactions: state.treasuriesWithTransactions,
              ),
              onRefresh: () => _onRefresh(context),
            );
          } else if (state is ErrorTreasuriesWithTransactionsState) {
            return MessageDisplayWidget(
              message: state.message,
              isSuccess: false,
            );
          }
          return LoadingWidget();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<TreasuriesBloc>(
      context,
    ).add(refreshTreasuriesWithTransactionsEvent());
  }

  Widget _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddTreasuryDialog(context),
      child: Icon(Icons.add),
    );
  }

  void _showAddTreasuryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TreasuryDialog(
        treasury: null,
        isUpdateTreasury: false,
        onConfirm: (title) {
          // Handle treasury creation
          print('Creating treasury with title: $title');
          // Add your creation logic here
          _validateFormThenAddTreasury(context, title);
        },
      ),
    );
  }

  void _validateFormThenAddTreasury(BuildContext context, String title) {
    final treasury = Treasury(id: null, title: title, deleted: false);
    BlocProvider.of<TreasuriesAddEditDeleteBloc>(
      context,
    ).add(AddTreasuryEvent(treasury: treasury));
  }
}
