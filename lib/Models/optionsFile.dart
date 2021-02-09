class OptionsModel {
  var id;
  var question_id;
  var option;
  var order;

  OptionsModel(
      {this.id, this.question_id, this.option, this.order});

  factory OptionsModel.fromMap(Map item) {
    return OptionsModel(
        id: item['id'],
        question_id: item['question_id'],
        option: item['option'],
        order: item['order']);
  }
  show() {
    print('id: $id');
    print('question_id: $question_id');
    print('option: $option');
    print('order: $order');
  }
}