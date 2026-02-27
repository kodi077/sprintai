import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conversation_model.dart';
import '../models/sprint_plan_model.dart';
import '../models/stack_model.dart';

class AppProvider extends ChangeNotifier {
  User? currentUser;
  List<ConversationModel> conversations = <ConversationModel>[];
  ConversationModel? activeConversation;
  SprintPlan? currentSprintPlan;
  StackSelection stackSelection = StackSelection.empty();
  String prdText = '';
  bool isLoading = false;
  String? errorMessage;

  void setUser(User? user) {
    if (currentUser == user) {
      return;
    }
    currentUser = user;
    notifyListeners();
  }

  void setStackFrontend(String? value) {
    if (stackSelection.frontend == value) {
      return;
    }
    stackSelection.frontend = value;
    notifyListeners();
  }

  void setStackBackend(String? value) {
    if (stackSelection.backend == value) {
      return;
    }
    stackSelection.backend = value;
    notifyListeners();
  }

  void setStackDatabase(String? value) {
    if (stackSelection.database == value) {
      return;
    }
    stackSelection.database = value;
    notifyListeners();
  }

  void setPrdText(String text) {
    if (prdText == text) {
      return;
    }
    prdText = text;
    notifyListeners();
  }

  void setLoading(bool value) {
    if (isLoading == value) {
      return;
    }
    isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    if (errorMessage == message) {
      return;
    }
    errorMessage = message;
    notifyListeners();
  }

  void setSprintPlan(SprintPlan? plan) {
    if (identical(currentSprintPlan, plan)) {
      return;
    }
    currentSprintPlan = plan;
    notifyListeners();
  }

  void setConversations(List<ConversationModel> list) {
    conversations = list;
    notifyListeners();
  }

  void setActiveConversation(ConversationModel? c) {
    if (identical(activeConversation, c)) {
      return;
    }
    activeConversation = c;
    notifyListeners();
  }

  void clearSession() {
    prdText = '';
    currentSprintPlan = null;
    errorMessage = null;
    activeConversation = null;
    notifyListeners();
  }
}
