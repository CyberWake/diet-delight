class PostQuestionnaire {
  int userId;
  int questionId;
  int answerOptionId;
  String answer;
  String questionQuestion;
  int questionType;
  String questionAdditionalText;
  String answerOptionOption;

  PostQuestionnaire({
    this.userId,
    this.questionId,
    this.answerOptionId,
    this.answer,
    this.questionQuestion,
    this.questionType,
    this.questionAdditionalText,
    this.answerOptionOption,
  });

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'user_id': this.userId,
      'question_id': this.questionId,
      'answer_option_id': this.answerOptionId,
      'answer': this.answer,
      'question_question': this.questionQuestion,
      'question_type': this.questionType,
      'question_additional_text': this.questionAdditionalText,
      'answer_option_option': this.answerOptionOption,
    } as Map<String, dynamic>;
  }

  addUserId(int userId) {
    this.userId = userId;
  }
}
