

class CommentModel {

  List<Comment> comments=[];

  CommentModel();
  CommentModel.fromMap(map) {
    for(var item in map){
      comments.add(Comment(item));
    }
  }
}

class Comment{
  int? commentId;
  String? comment;
  String? name;
  String? image;
  DateTime? createdAt;

  Comment(map){
    commentId=map["CommentId"];
    comment=map["Comment"];
    image=map["Image"];
    createdAt=DateTime.parse(map["CreatedAt"]);
    name=map["Name"];
  }

}

