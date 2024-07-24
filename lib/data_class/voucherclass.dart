class Voucherclass {
  final String docID;
  final String voucherName;
  final double amount;
  final DateTime startDate;
  final DateTime expiryDate;
  final String vstatus;

  Voucherclass({
    required this.docID,
    required this.voucherName,
    required this.amount,
    required this.startDate,
    required this.expiryDate,
    required this.vstatus,
  });
}
