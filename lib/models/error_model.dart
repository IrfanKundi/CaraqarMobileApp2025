class ErrorModel {
  final int? errorCode;
  final  data;
  final String? title;
  final String? message;

  ErrorModel({this.errorCode, this.data,this.message="", this.title="Error"});
}
