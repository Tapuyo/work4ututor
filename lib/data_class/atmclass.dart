class ATMCard {
  final String cardNumber;
  final String cardHolderName;
  final String expirationDate;
  final String bankName;
  final String cardType;

  ATMCard(
      {required this.cardNumber,
      required this.cardHolderName,
      required this.expirationDate,
      required this.bankName,
      required this.cardType,});
}