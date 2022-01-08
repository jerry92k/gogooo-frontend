class InterestCategory {
  String interestCategoryId;
  String interestCategoryNm;
  bool isSelected;

  InterestCategory(
      {this.interestCategoryId,
      this.interestCategoryNm,
      this.isSelected = false});

  InterestCategory.fromJson(Map<String, dynamic> json)
      : interestCategoryId = json['INTEREST_CATEGORY_ID'],
        interestCategoryNm = json['INTEREST_CATEGORY_NM'],
        isSelected = false;

  Map<String, dynamic> toJson() => {
        'interestCategoryId': interestCategoryId,
        'interestCategoryNm': interestCategoryNm,
        'isSelected': isSelected,
      };

  void toggleSelected() {
    isSelected = !isSelected;
  }
}
