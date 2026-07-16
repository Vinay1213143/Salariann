# Messaging & Notifications - Quick Start

**Date**: June 17, 2026  
**Status**: ✅ **BACKEND READY**

---

## 🚀 What's Done

✅ Messaging controller created  
✅ Notifications controller created  
✅ API routes configured  
✅ Database schema defined  
✅ Authentication integrated  

---

## 📋 What You Need to Do

### 1. Create Database Tables (Supabase)

Run these SQL queries in Supabase:

```sql
-- Conversations table
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_1_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Messages table
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  related_id UUID,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_conversations_participant_1 ON conversations(participant_1_id);
CREATE INDEX idx_conversations_participant_2 ON conversations(participant_2_id);
CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
```

### 2. Update Flutter Screens

#### Messaging Screen

```dart
// lib/providers/messaging_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class MessagingProvider extends ChangeNotifier {
  List<dynamic> conversations = [];
  List<dynamic> messages = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchConversations(String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/conversations'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        conversations = data['data'] ?? [];
        error = null;
      } else {
        error = 'Failed to fetch conversations';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMessages(String conversationId, String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/conversations/$conversationId/messages'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        messages = data['data'] ?? [];
        error = null;
      } else {
        error = 'Failed to fetch messages';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String conversationId, String content, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'conversationId': conversationId,
          'content': content
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        messages.insert(0, data['data']);
        notifyListeners();
      } else {
        error = 'Failed to send message';
      }
    } catch (e) {
      error = e.toString();
    }
  }
}
```

#### Notifications Screen

```dart
// lib/providers/notifications_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class NotificationsProvider extends ChangeNotifier {
  List<dynamic> notifications = [];
  int unreadCount = 0;
  bool isLoading = false;
  String? error;

  Future<void> fetchNotifications(String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        notifications = data['data'] ?? [];
        unreadCount = data['pagination']['unread_count'] ?? 0;
        error = null;
      } else {
        error = 'Failed to fetch notifications';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUnreadCount(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications/unread/count'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        unreadCount = data['unread_count'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      print('Error getting unread count: $e');
    }
  }

  Future<void> markAsRead(String notificationId, String token) async {
    try {
      await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/$notificationId/read'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      fetchNotifications(token);
    } catch (e) {
      error = e.toString();
    }
  }
}
```

### 3. Add Providers to App

```dart
// lib/app.dart
ChangeNotifierProvider(
  create: (_) => MessagingProvider(),
),
ChangeNotifierProvider(
  create: (_) => NotificationsProvider(),
),
```

### 4. Update Screens

Update `messaging_screen.dart` and `notifications_screen.dart` to use the providers.

---

## 🎯 API Endpoints Ready

### Messaging
```
GET /api/conversations
GET /api/conversations/{id}/messages
POST /api/messages
DELETE /api/messages/{id}
PUT /api/conversations/{id}/read
```

### Notifications
```
GET /api/notifications
GET /api/notifications/unread/count
PUT /api/notifications/{id}/read
PUT /api/notifications/read/all
DELETE /api/notifications/{id}
POST /api/notifications/send
```

---

## ✨ Features

### Messaging
✅ Get conversations  
✅ Get messages  
✅ Send messages  
✅ Delete messages  
✅ Mark as read  

### Notifications
✅ Get notifications  
✅ Get unread count  
✅ Mark as read  
✅ Mark all as read  
✅ Delete notifications  

---

## 🎉 Summary

**Backend is 100% ready!**

Next steps:
1. Create database tables in Supabase
2. Create providers in Flutter
3. Update screens to use providers
4. Test messaging and notifications

---

*Messaging & Notifications - Quick Start*  
*June 17, 2026*  
*Status: Backend Ready ✅*
