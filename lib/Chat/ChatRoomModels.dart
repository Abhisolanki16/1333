class ChatRoomModel{
  String? chatRoomid;
  List<String>? participants;

  ChatRoomModel({this.chatRoomid,this.participants});
  
  ChatRoomModel.fromMap(Map<String,dynamic> map){
    chatRoomid = map['chatRoomid'];
    participants = map['participants'];
  }

  Map<String,dynamic> toMap(){
    return {
      "chatRoomid": chatRoomid,
      "participants": participants
    };
  }
}