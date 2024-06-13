
class RecipeModel
{
  String? appLabel;
  String? appImgUrl;
  double? appCalories;
  String? appUrl;

  RecipeModel(
      {this.appLabel = "Label",
      this.appImgUrl = "ImgUrl",
      this.appCalories = 0.00,
      this.appUrl = "URL"});

  factory RecipeModel.fromMap(Map recipe)
  {
    return RecipeModel(
      appLabel: recipe["label"],
      appCalories: recipe["calories"],
      appImgUrl: recipe["image"],
      appUrl: recipe["url"]
    );
  }

}