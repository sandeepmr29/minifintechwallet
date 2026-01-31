import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../shared_widgets/loaders/circular_loader.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import 'transaction_page.dart';
import '../../../../injection_container.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final Color primaryColor = const Color(0xFFBA1E1E); // theme color

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(LoadWalletEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<AuthBloc>(),
                        child: LoginPage(),
                      ),
                    ),
                  );
                },
              ),
              title: const Text(
                'Wallet Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: primaryColor,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<WalletBloc>(),
                          child: const TransactionPage(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            backgroundColor: Colors.grey[100],
            body: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading || state is WalletInitial) {
                  return const Center(child: CircularLoader());
                }

                if (state is WalletLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<WalletBloc>().add(LoadWalletEvent());
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Balance Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: Colors.black26,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Balance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${state.balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Transactions Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              color: primaryColor,
                              onPressed: () {
                                context.read<WalletBloc>().add(
                                  LoadWalletEvent(),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Transaction List
                        if (state.transactions.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'No transactions yet',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.transactions.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final tx = state.transactions[index];
                              final formattedDate = DateFormat(
                                'dd-MM-yyyy hh:mm a',
                              ).format(DateTime.parse(tx.timestamp));
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: tx.type == 'credit'
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    child: Icon(
                                      tx.type == 'credit'
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: tx.type == 'credit'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  title: Text(
                                    '\$${tx.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(formattedDate),
                                  trailing: Text(
                                    tx.type.toUpperCase(),
                                    style: TextStyle(
                                      color: tx.type == 'credit'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                }

                if (state is WalletError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
