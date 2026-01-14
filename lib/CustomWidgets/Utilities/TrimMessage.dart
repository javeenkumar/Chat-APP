
String TrimMessage(String message){
  if (message.contains(']')) {
    message = message.split(']').last.trim();
    return message;
  }else {
    return message;
  }
}