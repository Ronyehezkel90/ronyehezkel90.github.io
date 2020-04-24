class Record {
  final String entrepreneur;
  final String dealDate;
  final int apartmentNumber;
  final int price;
  final int legalPayment;
  final String project;
  final String buyers;
  final bool isMishtakenPrice;

  Record(
      {this.entrepreneur,
      this.dealDate,
      this.apartmentNumber,
      this.project,
      this.buyers,
      this.price,
      this.isMishtakenPrice,
      this.legalPayment});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['project'] = project;
    map['entrepreneur'] = entrepreneur;
    map['dealDate'] = dealDate;
    map['apartmentNumber'] = apartmentNumber;
    map['buyers'] = buyers;
    map['price'] = price;
    map['legalPayment'] = legalPayment;
    map['isMishtakenPrice'] = isMishtakenPrice;
    return map;
  }

  factory Record.fromJson(Map<String, dynamic> recordJson) {
    return Record(
      entrepreneur: recordJson["entrepreneur"],
      dealDate: recordJson["dealDate"],
      apartmentNumber: recordJson["apartmentNumber"],
      project: recordJson["project"],
      buyers: recordJson["buyers"],
      price: recordJson["price"],
      legalPayment: recordJson["legalPayment"],
      isMishtakenPrice: recordJson["isMishtakenPrice"],
    );
  }

  @override
  String toString() {
    return "record: entrepreneur:$entrepreneur dealDate:$dealDate apartmentNumber:$apartmentNumber project:$project buyers:$buyers price:$price legalPayment:$legalPayment isMishtakenPrice:$isMishtakenPrice";
  }
}
