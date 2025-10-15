import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpletreasury/core/utils/snackbar_message.dart';
import 'package:simpletreasury/core/widgets/loading_widget.dart';
import 'package:simpletreasury/features/transactions/domain/entities/transaction.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';
import 'package:simpletreasury/features/treasuries/presentation/bloc/treasuries_add_edit_delete/treasuries_add_edit_delete_bloc.dart';
import 'package:simpletreasury/features/treasuries/presentation/pages/treasuries_page.dart';
import 'package:simpletreasury/features/treasuries/presentation/widgets/treasury_add_update_widget.dart';

class TransactionsPage extends StatelessWidget {
  final TreasuryWithTransactions treasuryWithTransactions;

  const TransactionsPage({super.key, required this.treasuryWithTransactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Off-White background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2B4C), // Navy Blue
        title: Text(
          treasuryWithTransactions.treasury.title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Edit Treasury Button
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showEditTreasuryDialog(
              context,
              treasuryWithTransactions.treasury,
            ),
          ),
          // Delete Treasury Button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // Delete treasury functionality would go here
              _showDeleteTreasuryDialog(
                context,
                treasuryWithTransactions.treasury,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Card
          _buildBalanceCard(),

          // Transactions Header
          _buildTransactionsHeader(),

          // Transactions List
          _buildTransactionsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new transaction functionality would go here
        },
        backgroundColor: const Color(0xFF1A2B4C), // Navy Blue
        elevation: 4.0, // Slightly stronger shadow for FAB
        child: const Icon(Icons.add, color: Colors.white, size: 28.0),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        elevation: 2.0, // Subtle shadow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Total Balance" - Subtitle style
              const Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333), // Charcoal
                ),
              ),
              const SizedBox(height: 8.0),

              // Balance Figure - Headline style with Navy Blue
              Text(
                '\$${treasuryWithTransactions.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2B4C), // Navy Blue
                ),
              ),
              const SizedBox(height: 12.0),

              // Summary info - Body style
              _buildTransactionSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSummary() {
    final totalImports = treasuryWithTransactions.transactions
        .where((t) => t.type == TransactionType.import && !t.deleted)
        .fold(0.0, (sum, t) => sum + t.value);

    final totalExports = treasuryWithTransactions.transactions
        .where((t) => t.type == TransactionType.export && !t.deleted)
        .fold(0.0, (sum, t) => sum + t.value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Imports',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF708090).withOpacity(0.8), // Slate Gray
              ),
            ),
            Text(
              '\$${totalImports.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Color(0xFF2E8B57), // Emerald Green
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Exports',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF708090).withOpacity(0.8), // Slate Gray
              ),
            ),
            Text(
              '\$${totalExports.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Color(0xFFDC143C), // Crimson Red
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333), // Charcoal
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: const Color(0xFF708090).withOpacity(0.1), // Slate Gray
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              '${treasuryWithTransactions.transactions.length}',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: Color(0xFF708090), // Slate Gray
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (treasuryWithTransactions.transactions.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 64.0,
                color: const Color(0xFF708090).withOpacity(0.3), // Slate Gray
              ),
              const SizedBox(height: 16.0),
              const Text(
                'No transactions yet',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF708090), // Slate Gray
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Add your first transaction by tapping the + button',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF708090), // Slate Gray
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: treasuryWithTransactions.transactions.length,
        itemBuilder: (context, index) {
          final transaction = treasuryWithTransactions.transactions[index];
          return _buildTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        elevation: 2.0, // Subtle shadow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Transaction Type Indicator
              Container(
                width: 4.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: transaction.type == TransactionType.import
                      ? const Color(0xFF2E8B57) // Emerald Green for imports
                      : const Color(0xFFDC143C), // Crimson Red for exports
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(width: 16.0),

              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Title - Subtitle style
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333), // Charcoal
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),

                    // Transaction Date - Caption style
                    Text(
                      _formatDate(transaction.date),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF708090), // Slate Gray
                      ),
                    ),
                  ],
                ),
              ),

              // Transaction Amount
              Text(
                '${transaction.type == TransactionType.import ? '+' : '-'}\$${transaction.value.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: transaction.type == TransactionType.import
                      ? const Color(0xFF2E8B57) // Emerald Green
                      : const Color(0xFFDC143C), // Crimson Red
                ),
              ),

              const SizedBox(width: 16.0),

              // Action Buttons
              Row(
                children: [
                  // Edit Button
                  IconButton(
                    onPressed: () {
                      // Edit transaction functionality would go here
                    },
                    icon: Icon(
                      Icons.edit,
                      color: const Color(0xFF008080), // Teal
                      size: 20.0,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const SizedBox(width: 8.0),

                  // Delete Button
                  IconButton(
                    onPressed: () {
                      // Delete transaction functionality would go here
                    },
                    icon: Icon(
                      Icons.delete,
                      color: const Color(0xFFDC143C), // Crimson Red
                      size: 20.0,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditTreasuryDialog(BuildContext context, Treasury treasury) {
    showDialog(
      context: context,
      builder: (context) => TreasuryDialog(
        treasury: treasury,
        isUpdateTreasury: true,
        onConfirm: (title) {
          // Handle treasury update
          print('Updating treasury to title: $title');
          _validateFormThenUpdateTreasury(context, title, treasury.id!);
        },
      ),
    );
  }

  void _showDeleteTreasuryDialog(BuildContext context, Treasury treasury) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: () {
          // Handle treasury delete
          _deleteTreasuryAfterConfirm(context, treasury.id!);
        },
      ),
    );
  }

  void _validateFormThenUpdateTreasury(
    BuildContext context,
    String title,
    String treasuryId,
  ) {
    final treasury = Treasury(id: treasuryId, title: title, deleted: false);
    BlocProvider.of<TreasuriesAddEditDeleteBloc>(
      context,
    ).add(UpdateTreasuryEvent(treasury: treasury));
  }

  void _deleteTreasuryAfterConfirm(BuildContext context, String treasuryId) {
    BlocProvider.of<TreasuriesAddEditDeleteBloc>(
      context,
    ).add(SoftDeleteTreasuryEvent(treasuryId: treasuryId));
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({Key? key, required this.onConfirm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => TreasuriesPage()),
                  (route) => false,
                );
              } else if (state is ErrorAddEditDeleteTreasuryState) {
                SnackbarMessage().showErrorSnackBar(
                  message: state.message,
                  context: context,
                );
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state is LoadingAddEditDeleteTreasuryState) {
                return LoadingWidget();
              }
              return AlertDialog(
                title: Text('Confirm Delete'),
                content: Text('Are you sure you want to delete this item?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      onConfirm(); // Perform delete action
                    },
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          ),
    );
  }
}
