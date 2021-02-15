class OptionsModel {
  var id;
  var question_Id;
  var option;
  var order;

  OptionsModel({this.id, this.question_Id, this.option, this.order});

  factory OptionsModel.fromMap(Map item) {
    return OptionsModel(
        id: item['id'],
        question_Id: item['question_id'],
        option: item['option'],
        order: item['order']);
  }
  show() {
    print('id: $id');
    print('question_id: $question_Id');
    print('option: $option');
    print('order: $order');
  }
}
