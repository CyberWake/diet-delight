class QuestionnaireModel {
  int id;
  String question;
  int type;
  int additionText;
  int order;

  QuestionnaireModel(
      {this.id, this.question, this.type, this.additionText, this.order});

  factory QuestionnaireModel.fromMap(Map item) {
    return QuestionnaireModel(
        id: item['id'],
        question: item['question'],
        type: item['type'],
        additionText: item['addition_text'],
        order: item['order']);
  }
  show() {
    print('id: $id');
    print('question: $question');
    print('type: $type');
    print('additionText: $additionText');
    print('order: $order');
  }
}
