import 'ticket_model.dart';

class WalletTransaction {
  final String id;
  final String title;
  final String subtitle;
  final String dateGroup;
  final int amount;
  final bool isCredit;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateGroup,
    required this.amount,
    required this.isCredit,
  });

  String get formattedSignedAmount {
    final prefix = isCredit ? '+' : '−';
    return '$prefix${ParkingTicket.formatRupiah(amount)}';
  }

  static const List<WalletTransaction> defaultHistory = [
    WalletTransaction(
      id: 'trx-1',
      title: 'Parkir gedung',
      subtitle: 'Senayan City • 14.55',
      dateGroup: '8 Oktober 2026',
      amount: 10000,
      isCredit: false,
    ),
    WalletTransaction(
      id: 'trx-2',
      title: 'Layanan valet',
      subtitle: 'Senayan City • 12.58',
      dateGroup: '8 Oktober 2026',
      amount: 35000,
      isCredit: false,
    ),
    WalletTransaction(
      id: 'trx-3',
      title: 'Isi saldo',
      subtitle: 'BCA • 19.20',
      dateGroup: '7 Oktober 2026',
      amount: 250000,
      isCredit: true,
    ),
  ];
}

