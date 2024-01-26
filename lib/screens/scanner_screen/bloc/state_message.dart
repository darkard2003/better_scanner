enum StateMessageType { error, success, info }

class StateMessage {
  final String message;
  final StateMessageType type;
  final MessageAction? action;

  StateMessage({
    required this.message,
    this.type = StateMessageType.info,
    this.action,
  });
}

class MessageAction {
  final String name;
  final void Function() action;

  MessageAction(this.name, this.action);
}
