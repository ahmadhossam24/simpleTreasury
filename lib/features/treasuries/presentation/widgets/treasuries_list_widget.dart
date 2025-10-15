import 'package:flutter/material.dart';
import 'package:simpletreasury/features/transactions/presentation/pages/treasury_transactions_page.dart';
import 'package:simpletreasury/features/treasuries/domain/entities/treasury_with_transactions.dart';

class TreasuriesListWidget extends StatelessWidget {
  final List<TreasuryWithTransactions> treasuriesWithTransactions;
  const TreasuriesListWidget({
    super.key,
    required this.treasuriesWithTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // Off-White background
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: treasuriesWithTransactions.length,
        itemBuilder: (context, index) {
          final treasuryWithTransactions = treasuriesWithTransactions[index];
          return _TreasuryListItem(
            treasuryWithTransactions: treasuryWithTransactions,
            onTap: () => _handleTreasuryTap(context, treasuryWithTransactions),
          );
        },
      ),
    );
  }

  void _handleTreasuryTap(
    BuildContext context,
    TreasuryWithTransactions treasuryWithTransactions,
  ) {
    // Navigate to treasury details page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionsPage(
          treasuryWithTransactions: treasuryWithTransactions,
        ),
      ),
    );
  }
}

class _TreasuryListItem extends StatelessWidget {
  final TreasuryWithTransactions treasuryWithTransactions;
  final VoidCallback onTap;

  const _TreasuryListItem({
    Key? key,
    required this.treasuryWithTransactions,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        elevation: 2.0, // Subtle shadow
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Treasury Image
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://th.bing.com/th/id/R.9217b9891debaf3679b6f06c2a2db712?rik=vhRZ%2fBTyKgvyZA&pid=ImgRaw&r=0",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),

                // Treasury Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title - Subtitle style
                      Text(
                        treasuryWithTransactions.treasury.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333), // Charcoal
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),

                      // Balance - Body style with Navy Blue
                      Text(
                        '\$${treasuryWithTransactions.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF1A2B4C), // Navy Blue
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron icon
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF708090), // Slate Gray
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
