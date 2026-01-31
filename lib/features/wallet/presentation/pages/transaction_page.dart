import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _amountController = TextEditingController();
  String _transactionType = 'credit'; // default
  final _formKey = GlobalKey<FormState>();

  final Color primaryColor = const Color(0xFFBA1E1E); // Primary theme color

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);

      final transaction = TransactionEntity(
        id: const Uuid().v4(),
        amount: amount,
        type: _transactionType,
        status: 'pending',
        timestamp: DateTime.now().toIso8601String(),
      );

      context.read<WalletBloc>().add(AddTransactionEvent(transaction));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          // Professional neutral background
          Container(color: Colors.grey[100]),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'New Transaction',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Amount must be greater than 0';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _transactionType,
                            items: const [
                              DropdownMenuItem(
                                value: 'credit',
                                child: Text('Credit'),
                              ),
                              DropdownMenuItem(
                                value: 'debit',
                                child: Text('Debit'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _transactionType = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Transaction Type',
                              prefixIcon: Icon(
                                Icons.swap_horiz,
                                color: primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: primaryColor,
                              ),
                              onPressed: _submitTransaction,
                              child: const Text(
                                'Add Transaction',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
