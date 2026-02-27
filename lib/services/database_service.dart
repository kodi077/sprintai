import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conversation_model.dart';

class DatabaseService {
  Future<ConversationModel> createConversation(
    ConversationModel conversation,
  ) async {
    final response = await Supabase.instance.client
        .from('conversations')
        .insert(conversation.toInsertMap())
        .select()
        .single();
    return ConversationModel.fromJson(response);
  }

  Future<List<ConversationModel>> fetchConversations(String userId) async {
    final response = await Supabase.instance.client
        .from('conversations')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response
        .map<ConversationModel>((row) => ConversationModel.fromJson(row))
        .toList();
  }

  Future<void> saveMessage(MessageModel message) async {
    await Supabase.instance.client
        .from('messages')
        .insert(message.toInsertMap());
  }

  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    final response = await Supabase.instance.client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return response
        .map<MessageModel>((row) => MessageModel.fromJson(row))
        .toList();
  }
}
