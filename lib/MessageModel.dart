class MessageModel{
  String? recieverId;
  String? senderId;
  String? senderName;
  String? receiverName;
  String? messageBody;
  int? createdAt;

  MessageModel({
    this.recieverId,
    this.senderId,
    this.messageBody,
    this.createdAt,
    this.senderName,
    this.receiverName,
  });

  MessageModel.fromData(Map<String,dynamic> data)
  : recieverId = data['recieverId'],
    senderId = data['senderid'],
    senderName = data['senderName'],
    receiverName = data['receiverName'],
    messageBody = data['messageBody'],
    createdAt = data['createdAt'];

    static MessageModel fromMap(Map<String,dynamic> map){
      return MessageModel(
        recieverId : map['recieverId'],
        senderId : map['senderid'],
        senderName : map['senderName'],
        receiverName : map['receiverName'],
        messageBody : map['messageBody'],
        createdAt : map['createdAt']

      );
    }

    Map<String,dynamic> toJson(){
      return {
        'recieverId' : recieverId,
        'senderId' : senderId,
        'senderName' : senderName,
        'receiverName' : receiverName,
        'messageBody' : messageBody,
        'createdAt' : createdAt

      };
    }
    
  
}