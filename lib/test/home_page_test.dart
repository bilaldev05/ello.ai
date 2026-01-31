import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ello_ai/src/ui/home_page.dart'; 
// -------------------------
// Fake models for testing
// -------------------------
class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage({required this.content, required this.isUser});
}

enum ConnectionStatus { connected, connecting, disconnected }

// -------------------------
// Fake providers for testing
// -------------------------
final chatHistoryProvider =
    StateProvider<List<ChatMessage>>((ref) => []);

final chatProvider =
    StateNotifierProvider<ChatNotifierMock, List<ChatMessage>>(
        (ref) => ChatNotifierMock());

final useMockGrpcProvider = StateProvider<bool>((ref) => false);
final connectionStatusProvider =
    StateProvider<ConnectionStatus>((ref) => ConnectionStatus.disconnected);
final hasActiveConversationProvider = StateProvider<bool>((ref) => false);
final conversationIdProvider = StateProvider<String?>((ref) => null);
final currentChatClientProvider =
    StateNotifierProvider<CurrentChatClientMock, int>((ref) => CurrentChatClientMock());

// -------------------------
// Fake Notifiers
// -------------------------
class ChatNotifierMock extends StateNotifier<List<ChatMessage>> {
  ChatNotifierMock() : super([]);

  void sendMessage(String msg) {
    state = [...state, ChatMessage(content: msg, isUser: true)];
  }

  void resetConversation() {
    state = [];
  }
}

class CurrentChatClientMock extends StateNotifier<int> {
  CurrentChatClientMock() : super(0);

  void updateClient() {
    state++;
  }
}

// -------------------------
// Tests
// -------------------------
void main() {
  testWidgets('HomePage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: HomePage()),
      ),
    );

    // Check if the title is present
    expect(find.text('ello.AI'), findsOneWidget);

    // Check if the TextField exists
    expect(find.byType(TextField), findsOneWidget);

    // Check if the send button exists
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}